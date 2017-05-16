class ProblemExample < ApplicationRecord
  belongs_to :problem

  validates :problem, presence: true
  validates :number, presence: true
  validates :input, presence: true
  validates :result, presence: true
end
