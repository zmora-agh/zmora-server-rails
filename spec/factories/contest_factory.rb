FactoryGirl.define do
  factory :contest do
    name 'contest name'
    shortcode
    duration 3600 * 24 * 5
    signup_duration 3600 * 24 * 2
    can_join_started false

    # just to satisfy factory_girl linter
    # by default in_progress
    start { 4.days.ago }

    trait :in_enrolment do
      start { 1.day.ago }
    end

    trait :before_signup do
      start { Date.tomorrow }
    end

    trait :in_progress do
      start { 4.days.ago }
    end

    trait :ended do
      start { 14.days.ago }
    end
  end
end
