class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :nick
      t.string :password_digest

      t.string :email
      t.string :name
      t.text :about

      t.attachment :avatar

      t.boolean :is_admin, default: false

      t.timestamps
    end
  end
end
