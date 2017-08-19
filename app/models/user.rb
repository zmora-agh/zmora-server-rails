require 'json_web_tokens'

class User < ApplicationRecord
  has_attached_file :avatar, styles: { medium: '300x300>', thumb: '100x100>' }
  has_secure_password
  has_many :problems, foreign_key: 'author_id'

  has_many :contest_ownerships, foreign_key: 'owner_id'
  has_many :owned_contests, class_name: 'Contest', through: :contest_ownerships
  has_many :contest_participations
  has_many :joined_contests, class_name: 'Contest', through: :contest_participations, source: :contest
  has_many :submits, foreign_key: 'author_id'

  validates :nick,  presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  def self.login(nick, password)
    user = User.find_by(nick: nick)
    return nil unless user
    return nil unless user.authenticate(password)
    payload = { nick: user.nick, name: user.name,
                about: user.about, id: user.id,
                admin: true }
    JsonWebTokens.encode(payload)
  end

  def self.register(nick, password, name, email)
    user = User.new(nick: nick, password: password, name: name, email: email)
    return nil unless user.save
    payload = { nick: user.nick, name: user.name, id: user.id, admin: true }
    JsonWebTokens.encode(payload)
  end

  def self.can_submit_to?(user_id, problem_id)
    contest = ContestProblem.find(problem_id).contest
    ContestParticipation.exists?(contest: contest, user_id: user_id) &&
      contest.in_progress? && !ContestProblem.hard_overdue?(problem_id)
  end

  def self.owner_of?(user_id, contest_id)
    Contest.find(contest_id).owners.where(id: user_id).exists?
  end

  def self.can_access_contest_problems?(user_id, contest)
    return false if contest.nil? || user_id.nil?
    contest.start + contest.signup_duration < Time.current ||
      User.owner_of?(user_id, contest.id)
  end

  def self.change_password(id, old_password, new_password)
    user = User.find(id)
    return false unless user
    return false unless user.authenticate(old_password)
    user.password = new_password
    user.save
  end

  def self.can_view_user_submits_in_problem?(viewer_id, author_id, problem)
    problem.contest.contest_participations.exists?(user_id: author_id, contest_owner: viewer_id) ||
      viewer_id == author_id
  end
end
