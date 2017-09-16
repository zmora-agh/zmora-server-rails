class AddCanJoinStartedFieldToContest < ActiveRecord::Migration[5.1]
  def change
    add_column :contests, :can_join_started, :boolean, null: false, default: false
    change_column_default :contests, :can_join_started, from: false, to: nil
  end
end
