class CreateContestProblems < ActiveRecord::Migration[5.1]
  def change
    create_table :contest_problems do |t|
      t.references :contest, index: true, foreign_key: true
      t.references :problem, index: true, foreign_key: true
      t.string :shortcode
      t.string :category
      t.integer :base_points
      t.timestamp :soft_deadline
      t.timestamp :hard_deadline
      t.boolean :required

      t.timestamps
    end
  end
end
