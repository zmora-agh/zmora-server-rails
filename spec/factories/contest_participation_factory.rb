FactoryGirl.define do
  factory :contest_participation do

    contest
    user
    association :contest_owner, factory: :user

    after(:create) do |participation, _|
      unless ContestOwnership.find_by(contest: participation.contest, owner: participation.contest_owner)

        create(:contest_ownership, owner: participation.contest_owner,
               contest: participation.contest)
      end
    end
  end
end
