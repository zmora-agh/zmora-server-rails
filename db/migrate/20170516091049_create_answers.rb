class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.references :question, index: true, foreign_key: true
      t.references :author, index: true, foreign_key: { to_table: :users }
      t.text :answer

      t.timestamps
    end
  end
end
