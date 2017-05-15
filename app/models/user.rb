class User < ApplicationRecord
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }
  has_secure_password
  has_many :problems, foreign_key: "author_id"

  has_many :contest_ownerships, foreign_key: "owner_id"
  has_many :contests, through: :contest_ownerships

  validates :nick,  presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
end
