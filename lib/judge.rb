require 'rabbitmq'
require 'judge_pb'

class Judge
  def self.create_task(submit)
    rabbit = RabbitMQ.new(Rails.configuration.tasks_queue_name, Rails.configuration.rabbitmq_uri)

    task = init_task(submit)
    rabbit.send(task.to_proto)

    rabbit.close
  end

  def self.start_receive_results
    rabbit = RabbitMQ.new(
      Rails.configuration.tasks_results_queue_name,
      Rails.configuration.rabbitmq_uri,
      Rails.configuration.tasks_results_error_queue_name
    )
    rabbit.start_receiving do |payload, delivery_info|
      Judge.handle_task_result(rabbit, payload, delivery_info)
    end
  end

  private_class_method
  def self.handle_task_result(rabbit, payload, delivery_info)
    result = TaskResult.decode(payload)
    save_result(delivery_info, rabbit, result)
  rescue => exception
    rabbit.send_error(payload)
    rabbit.ack(delivery_info.delivery_tag)
    Raven.capture_exception(exception)
    raise
  end

  private_class_method
  def self.save_result(delivery_info, rabbit, result)
    ActiveRecord::Base.connection_pool.with_connection do
      Submit.transaction do
        submit_status = create_tests_results(result)
        Submit.find(result.result_id).update!(status: submit_status)
        rabbit.ack(delivery_info.delivery_tag)
      end
    end
  end

  private_class_method
  def self.create_tests_results(result)
    submit_status = :ok
    result.tests_results.map do |test_result|
      submit_status = :err unless test_result.status == :OK
      TestResult.create!(status: map_task_status(test_result.status), test_id: test_result.source_test_id,
                         user_time: test_result.user_time, system_time: test_result.system_time,
                         ram_usage: test_result.ram_usage, submit_id: result.result_id)
    end
    submit_status
  end

  private_class_method
  def self.map_task_status(judge_status)
    judge_status.downcase
  end

  private_class_method
  def self.init_task(submit)
    Task.new(task_id: submit.id, files: init_files(submit), tests: init_tests(submit))
  end

  private_class_method
  def self.init_files(submit)
    submit.submit_files.all.map do |f|
      Task::File.new(file_id: f.id, name: f.file.original_filename, content: Paperclip.io_adapters.for(f.file).read)
    end
  end

  private_class_method
  def self.init_tests(submit)
    submit.contest_problem.tests.all.map do |t|
      Task::Test.new(test_id: t.id, input: t.input, output: t.output, time_limit: t.time_limit, ram_limit: t.ram_limit)
    end
  end
end
