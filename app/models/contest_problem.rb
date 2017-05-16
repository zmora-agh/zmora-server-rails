class ContestProblem < ApplicationRecord
  belongs_to :contest
  belongs_to :problem

  validates :contest, presence: true
  validates :problem, presence: true
  validates :shortcode, presence: true, uniqueness: {scope: :contest, case_sensitive: false}
  validates :category, presence: true
  validates :base_points, presence: true
  validates :soft_deadline, presence: true
  validates :required, presence: true
end
