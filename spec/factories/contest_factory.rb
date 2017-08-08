FactoryGirl.define do
  factory :contest do
    transient do
      in_progress true
    end

    name 'contest name'
    start { 1.day.ago }
    shortcode
    # contest is started (1.day.ago + 12 h < Time.current)
    signup_duration 3600 * 12
    # contest is in progess (1.day.ago + 12 h + 5 day > Time.current)
    duration 3600 * 24 * 5

    after(:create) do |contest, evaluator|
      contest.duration = 3600 * 8 unless evaluator.in_progress
    end
  end
end
