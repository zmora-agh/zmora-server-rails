FactoryGirl.define do
  factory :contest_participation do
    transient do
      create_ownership true
    end

    contest
    user
    association :contest_owner, factory: :user

    after(:create) do |contest_participation, evaluator|
      if evaluator.create_ownership
        create(:contest_ownership, owner: contest_participation.contest_owner,
                                   contest: contest_participation.contest)
      end
    end
  end
end
