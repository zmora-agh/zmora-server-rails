class SubmitFile < ApplicationRecord
  belongs_to :submit
  attr_readonly :file_fingerprint
  has_attached_file :file, adapter_options: { hash_digest: Digest::SHA256 }
  do_not_validate_attachment_file_type :file

  validates :submit, presence: true
  validates :file, presence: true
  validates :file_fingerprint, presence: true
end
