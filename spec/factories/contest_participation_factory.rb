require 'rails_helper'

FactoryGirl.define do
  factory :contest_participation do
    contest
    user
    association :contest_owner, factory: :user

    after(:create) do |contest_participation, _|
      create(:contest_ownership, owner: contest_participation.contest_owner,
             contest: contest_participation.contest)
    end
  end
end