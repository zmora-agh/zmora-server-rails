class Submit < ApplicationRecord
  enum status: [:ok, :que, :err]

  belongs_to :contest_problem
  belongs_to :author, class_name: "User"

  has_many :submit_files
  has_many :test_results

  validates :contest_problem, presence: true
  validates :author, presence: true
  validates :status, presence: true
end
