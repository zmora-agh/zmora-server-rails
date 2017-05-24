class ContestProblem < ApplicationRecord
  belongs_to :contest
  belongs_to :problem
  has_many :questions
  has_many :submits

  validates :contest, presence: true
  validates :problem, presence: true
  validates :shortcode, presence: true, uniqueness: { scope: :contest, case_sensitive: false }
  validates :category, presence: true
  validates :base_points, presence: true
  validates :soft_deadline, presence: true
  validates :required, presence: true

  def results(owner_id)
    results = []
    contest.contest_participations.where(contest_owner_id: owner_id).find_each do |participation|
      results.push(submits.order(status: :desc, created_at: :desc).find_by(author: participation.user))
    end
    results
  end
end
