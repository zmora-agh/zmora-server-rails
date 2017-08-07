class TestResult < ApplicationRecord
  belongs_to :submit
  belongs_to :test

  enum status: [:ok, :cme, :tle, :mem, :rte, :ans]

  validates :status, presence: true
  validates :execution_time, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :ram_usage, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
