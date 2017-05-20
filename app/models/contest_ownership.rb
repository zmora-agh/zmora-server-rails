class ContestOwnership < ApplicationRecord
  belongs_to :contest
  belongs_to :owner, class_name: 'User'

  validates :contest, presence: true
  validates :owner, presence: true, uniqueness: { scope: :contest }
  validates :join_password, presence: true, uniqueness: true
end
