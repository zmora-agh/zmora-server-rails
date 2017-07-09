class Test < ApplicationRecord
  belongs_to :contest_problem

  validates :input, presence: true
  validates :output, presence: true
  validates :time_limit, presence: true
  validates :ram_limit, presence: true
end
