FactoryGirl.define do
  factory :submit do
    contest_problem
    author
    status :ok
  end
end
