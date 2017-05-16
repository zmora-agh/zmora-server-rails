class Answer < ApplicationRecord
  belongs_to :author
  belongs_to :question

  validates :author, presence: true
  validates :answer, presence: true
end
