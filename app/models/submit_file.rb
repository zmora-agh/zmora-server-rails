class SubmitFile < ApplicationRecord
  belongs_to :submit
  attr_readonly :checksum

  validates :submit, presence: true
  validates :file, presence: true
  validates :checksum, presence: true
end
