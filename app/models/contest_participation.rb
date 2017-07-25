# coding: utf-8

class ContestParticipation < ApplicationRecord
  belongs_to :contest
  belongs_to :user

  # TODO: is it possible to validate that :contest_owner owns :contest ?
  belongs_to :contest_owner, class_name: 'User'

  validates :contest_id, presence: true, uniqueness: { scope: :user_id }
end
