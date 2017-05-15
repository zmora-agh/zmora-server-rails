class CreateProblems < ActiveRecord::Migration[5.1]
  def change
    create_table :problems do |t|
      t.references :author, index: true, foreign_key: { to_table: :users }

      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
