require 'rails_helper'

FactoryGirl.define do
  factory :user, aliases: [:author, :owner] do
    email
    nick
    password 'string_password'
    name 'Marcin'
  end
end
