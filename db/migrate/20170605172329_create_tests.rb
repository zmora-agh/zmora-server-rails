class CreateTests < ActiveRecord::Migration[5.1]
  def change
    create_table :tests do |t|
      t.references :contest_problem, index: true, foreign_key: true

      t.text :input
      t.text :output
      t.integer :time_limit
      t.integer :ram_limit

      t.timestamps
    end
  end
end
