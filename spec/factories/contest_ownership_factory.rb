FactoryGirl.define do
  factory :contest_ownership do
    association :contest, :in_progress
    owner
    join_password
  end
end
