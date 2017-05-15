class CreateContestOwnerships < ActiveRecord::Migration[5.1]
  def change
    create_table :contest_ownerships do |t|
      t.references :contest, index: true, foreign_key: true
      t.references :owner, index: true, foreign_key: { to_table: :users }
      t.string :join_password

      t.timestamps
    end
  end
end
