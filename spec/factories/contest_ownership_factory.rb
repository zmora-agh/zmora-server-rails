require 'rails_helper'

FactoryGirl.define do
  factory :contest_ownership do
    contest
    owner
    join_password
  end
end
