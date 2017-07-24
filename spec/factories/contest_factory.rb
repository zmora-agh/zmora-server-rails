require 'rails_helper'

FactoryGirl.define do
  factory :contest do
    name 'contest name'
    start {Time.now}
    signup_duration 1000
    duration 5000
    shortcode
  end
end