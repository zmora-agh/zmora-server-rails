class CreateTestResults < ActiveRecord::Migration[5.1]
  def change
    create_table :test_results do |t|
      t.references :submit, foreign_key: true
      t.integer :status
      t.integer :execution_time
      t.integer :ram_usage

      t.timestamps
    end
  end
end
