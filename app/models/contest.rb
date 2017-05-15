class Contest < ApplicationRecord
  validates :shortcode,  presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :start, presence: true
  validates :signup_duration, presence: true
  validates :duration, presence: true

  has_and_belongs_to_many :owners, through: :contest_ownership
end
