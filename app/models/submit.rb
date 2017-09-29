class Submit < ApplicationRecord
  enum status: [:ok, :que, :err]

  belongs_to :contest_problem
  belongs_to :author, class_name: 'User'

  has_many :submit_files
  has_many :test_results

  validates :contest_problem, presence: true
  validates :author, presence: true
  validates :status, presence: true

  scope :contest, (lambda { |contest_id, contest_owner_id|
    joins(contest_problem: :contest)
    .joins(:author)
    .joins('INNER JOIN "contest_participations" ON '\
      '"contests"."id" = "contest_participations"."contest_id" AND '\
      '"contest_participations"."user_id" = "submits"."author_id"')
    .where(contests: { id: contest_id }, contest_participations: { contest_owner_id: contest_owner_id })
  })

  def ok?
    status == 'ok'
  end

  def not_ok?
    !ok?
  end

  def self.contest_solutions(contest_id, contest_owner_id)
    attempts = ->(submits) { submits.sort_by(&:created_at).take_while(&:not_ok?).length + 1 }
    solutions = lambda do |submits|
      submits.group_by(&:contest_problem)
             .select { |_, problem_submits| problem_submits.any?(&:ok?) }
             .map { |problem, problem_submits| { problem: problem, attempts: attempts.call(problem_submits) } }
    end
    Submit.contest(contest_id, contest_owner_id).eager_load(:contest_problem, :author)
          .order('contest_problems.required DESC', 'contest_problems.created_at')
          .group_by(&:author)
          .map { |author, submits| { user: author, solutions: solutions.call(submits) } }
  end

  def author?(user_id)
    author.id == user_id
  end

  def in_contest_owned_by?(contest_owner_id)
    Submit.joins(contest_problem: { contest: :contest_participations })
          .exists?(id: id, contest_participations: { user_id: author.id, contest_owner_id: contest_owner_id })
  end
end
