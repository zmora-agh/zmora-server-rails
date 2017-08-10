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
  validates :required, presence: true

  # wszystkie submity do tego proglemu, które może oglądac dany prowadzący (od jkego podopiecznych)
  def results(owner_id)
    results = []
    contest.contest_participations.where(contest_owner_id: owner_id).find_each do |participation|
      submit = submits.order(status: :asc, created_at: :desc).find_by(author: participation.user)
      results.push(submit) if submit
    end
    results
  end
end
