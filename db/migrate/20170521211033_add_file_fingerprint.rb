class AddFileFingerprint < ActiveRecord::Migration[5.1]
  def change
    remove_column :submit_files, :checksum, :string
    add_column :submit_files, :file_fingerprint, :string
  end
end
