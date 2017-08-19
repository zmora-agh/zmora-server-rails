class ContestProblem < ApplicationRecord
  belongs_to :contest
  belongs_to :problem
  has_many :questions
  has_many :submits
  has_many :tests

  validates :contest, presence: true
  validates :problem, presence: true
  validates :shortcode, presence: true, uniqueness: { scope: :contest, case_sensitive: false }
  validates :category, presence: true
  validates :base_points, presence: true
  validates :soft_deadline, presence: true
  validates :hard_deadline, presence: true
  validates :required, presence: true

  # get all the submits for this problem that can be viewed by this owner
  # only one (newest with status OK) submit is retrieved per participant
  def results(owner_id)
    results = []
    contest.contest_participations.where(contest_owner_id: owner_id).find_each do |participation|
      best_submit_of_user = submits.order(status: :asc, created_at: :desc).find_by(author: participation.user)
      results.push(best_submit_of_user) if best_submit_of_user
    end
    results
  end

  def self.hard_overdue?(problem_id)
    ContestProblem.find(problem_id).hard_deadline < Time.current
  end
end
