class CreateSubmitFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :submit_files do |t|
      t.references :submit, foreign_key: true
      t.attachment :file
      t.string :checksum

      t.timestamps
    end
  end
end
