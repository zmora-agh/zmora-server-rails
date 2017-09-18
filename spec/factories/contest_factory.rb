FactoryGirl.define do
  factory :contest do
    name 'contest name'
    description 'Contest of your life'
    shortcode
    can_join_started false

    start { 2.days.ago }
    signup_duration 1.day
    duration 1.week

    trait :before_signup do
      start { 1.week.from_now }
    end

    trait :in_enrolment do
      start { 1.hour.ago }
    end

    trait :in_progress do
      # default
    end

    trait :in_progress_locked do
      # default
    end

    trait :in_progress_unlocked do
      can_join_started true
    end

    trait :ended do
      start { 1.year.ago }
    end
  end
end
