class TaskResultsMetricsBigint < ActiveRecord::Migration[5.1]
  def change
    rename_column :test_results, :execution_time, :user_time
    change_column :test_results, :user_time, :bigint
    add_column :test_results, :system_time, :bigint
    change_column :test_results, :ram_usage, :bigint
  end
end
