require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:nick) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }

  it { should validate_uniqueness_of(:nick).ignoring_case_sensitivity }
  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }

  it { should have_many(:problems) }
  it { should have_many(:contest_ownerships) }
  it { should have_many(:owned_contests) }
  it { should have_many(:joined_contests) }
end
