class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.references :author, index: true, foreign_key: { to_table: :users }
      t.text :question

      t.timestamps
    end
  end
end
