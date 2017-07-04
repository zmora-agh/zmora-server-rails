class AddTaskId < ActiveRecord::Migration[5.1]
  def change
    add_reference :test_results, :test, index: true, foreign_key: true
  end
end
