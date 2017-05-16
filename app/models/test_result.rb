class TestResult < ApplicationRecord
  belongs_to :submit

  enum status: [:ok, :cme, :tle, :mem, :rte, :err]

  validates :status, presence: true
  validates :execution_time, presence: true, numericality: {greater_than: 0}
  validates :ram_usage, presence: true, numericality: {greater_than: 0}
end
