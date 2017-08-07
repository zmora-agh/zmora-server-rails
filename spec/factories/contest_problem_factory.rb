require 'rails_helper'
FactoryGirl.define do
  factory :contest_problem do
    contest
    problem
    category 'cat'
    base_points 10
    soft_deadline { Date.tomorrow }
    required true
    shortcode
  end
end
