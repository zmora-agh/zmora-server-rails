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

  def self.contest_solutions(contest_id, contest_owner_id) # rubocop:disable Metrics/AbcSize
    attempts = {}

    Submit.contest(contest_id, contest_owner_id).eager_load(:contest_problem, :author).order(:status).map do |submit|
      author = submit.author
      problem = submit.contest_problem
      attempts[author] = {} unless attempts.member?(author)
      attempts[author][problem] = 0 if submit.status == 'ok' && !attempts[author].member?(problem)
      attempts[author][problem] += 1
    end

    attempts.map { |user, solution| { user: user, solutions: solution.map { |s| { problem: s[0], attempts: s[1] } } } }
  end

  def author?(user_id)
    author.id == user_id
  end

  def in_contest_owned_by?(contest_owner_id)
    Submit.joins(contest_problem: { contest: :contest_participations })
          .exists?(id: id, contest_participations: { user_id: author.id, contest_owner_id: contest_owner_id })
  end
end
