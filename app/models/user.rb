require 'json_web_tokens'

class User < ApplicationRecord # :nodoc:
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }
  has_secure_password
  has_many :problems, foreign_key: "author_id"

  has_many :contest_ownerships, foreign_key: "owner_id"
  has_many :contests, through: :contest_ownerships

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
end
