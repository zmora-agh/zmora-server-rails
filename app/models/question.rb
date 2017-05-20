class Question < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :answers

  validates :author, presence: true
  validates :question, presence: true
end
