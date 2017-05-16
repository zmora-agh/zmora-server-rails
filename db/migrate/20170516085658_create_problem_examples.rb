class CreateProblemExamples < ActiveRecord::Migration[5.1]
  def change
    create_table :problem_examples do |t|
      t.references :problem, foreign_key: true, index: true
      t.integer :number
      t.text :input
      t.text :result
      t.text :explanation

      t.timestamps
    end
  end
end
