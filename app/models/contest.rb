class Contest < ApplicationRecord
  validates :shortcode, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :start, presence: true
  validates :signup_duration, presence: true
  validates :duration, presence: true

  has_many :contest_ownerships
  has_many :owners, through: :contest_ownerships
  has_many :contest_participations
  has_many :users, through: :contest_participations

  has_many :contest_problems

  def in_progress?
    started? && start + signup_duration + duration > Time.current
  end

  def started?
    start + signup_duration < Time.current
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

  def self.join(user_id, contest_id, password)
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
end
