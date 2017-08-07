require 'rails_helper'

FactoryGirl.define do
  factory :problem do
    author
    name 'problem'
    description 'Lorem Ipsum ...'
  end
end
