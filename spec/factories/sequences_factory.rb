FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :shortcode do |n|
    "CODE#{n}"
  end

  sequence :nick do |n|
    "nick#{n}"
  end

  sequence :join_password do |n|
    "pass#{n}"
  end
end
