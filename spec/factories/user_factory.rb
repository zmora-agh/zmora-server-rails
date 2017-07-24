require 'rails_helper'
FactoryGirl.define do
  factory :user, aliases: [:author] do
    email
    nick
    password 'string_password'
    name 'Marcin'
  end
end