FactoryGirl.define do
  factory :contest_problem do
    association :contest, :in_progress
    problem
    category 'cat'
    base_points 10
    soft_deadline { Date.tomorrow }
    hard_deadline { Date.tomorrow }
    required true
    shortcode
  end
end
