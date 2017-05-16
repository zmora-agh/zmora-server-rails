class CreateSubmits < ActiveRecord::Migration[5.1]
  def change
    create_table :submits do |t|
      t.references :contest_problem, index: true, foreign_key: true
      t.references :author, index: true, foreign_key: { to_table: :users }
      t.integer :status

      t.timestamps
    end
  end
end
