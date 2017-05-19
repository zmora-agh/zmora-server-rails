class Problem < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "author_id"
  has_many :examples, class_name: "ProblemExample"

  validates :author, presence: true
  validates :name, presence: true
  validates :description, presence: true
end
