class CreateContests < ActiveRecord::Migration[5.1]
  def change
    create_table :contests do |t|
      t.string :shortcode
      t.string :name
      t.timestamp :start
      t.integer :signup_duration
      t.integer :duration
      t.string :description

      t.timestamps
    end
  end
end
