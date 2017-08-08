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

  def user_participates?(user_id)
    users.exists?(id: user_id)
  end

  def self.join(user_id, contest_id, password)
    # TODO: user should only join in time between start and  start  + signup duration
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
