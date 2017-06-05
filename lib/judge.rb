require 'rabbitmq'
require 'judge_pb'

class Judge
  def self.create_task(submit)
    rabbit = RabbitMQ.new('tasks')

    task = init_task(submit)
    rabbit.send(task.to_proto)

    rabbit.close
  end

  private_class_method
  def self.init_task(submit)
    Task.new(task_id: submit.id, configuration: '', files: init_files(submit), tests: init_tests(submit))
  end

  private_class_method
  def self.init_files(submit)
    submit.submit_files.all.map do |f|
      Task::File.new(name: f.file.original_filename, content: Paperclip.io_adapters.for(f.file).read)
    end
  end

  private_class_method
  def self.init_tests(submit)
    submit.contest_problem.tests.all.map do |t|
      Task::Test.new(test_id: t.id, input: t.input, output: t.output, time_limit: t.time_limit, ram_limit: t.ram_limit)
    end
  end
end
