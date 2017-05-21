class CreateContestParticipations < ActiveRecord::Migration[5.1]
  def change
    create_table :contest_participations do |t|
      t.references :contest, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :contest_owner, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :contest_participations, [:contest_id, :user_id], :unique => true
  end
end
