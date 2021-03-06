class Contest < ApplicationRecord
  validates :shortcode, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :start, presence: true
  validates :signup_duration, presence: true
  validates :duration, presence: true
  validates :can_join_started, inclusion: [true, false]

  has_many :contest_ownerships
  has_many :owners, through: :contest_ownerships
  has_many :contest_participations
  has_many :users, through: :contest_participations

  has_many :contest_problems

  # Are users able to submit new solutions now?
  def in_progress?
    started? && start + signup_duration + duration > Time.current
  end

  # Were users (or still are) able to submit new solutions?
  def started?
    start + signup_duration < Time.current
  end

  def in_enrolment?
    start < Time.current && !started?
  end

  def submit_metrics(contest_owner_id)
    statuses_count = Submit.joins(contest_problem: { contest: :contest_participations })
                           .where(contests: { id: id }, contest_participations: { contest_owner_id: contest_owner_id })
                           .where('contest_participations.user_id = submits.author_id')
                           .group(:status).count
    Submit.statuses.keys.map do |status|
      { status: status, submits: statuses_count.key?(status) ? statuses_count[status] : 0 }
    end
  end

  def user_participates?(user_id)
    users.exists?(id: user_id)
  end

  def self.can_join(contest_id)
    contest = Contest.find(contest_id)
    contest&.in_enrolment? || (contest&.can_join_started && contest&.in_progress?)
  end

  def self.join(user_id, contest_id, password)
    return nil unless can_join(contest_id)
    ownership = ContestOwnership.find_by(contest_id: contest_id, join_password: password)
    return nil unless ownership
    participation = ContestParticipation.new(
      contest_id: contest_id,
      user_id: user_id,
      contest_owner_id: ownership.owner.id
    )
    raise ArgumentError if participation.invalid? && participation.errors[:contest_id].any?
    participation.save
  end

  def participations(owner_id)
    contest_participations.where(contest_owner: owner_id).order(:created_at).map do |participation|
      { user: participation.user, joined: participation.created_at }
    end
  end
end
