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

  it "can't register 2 users with the same nick" do
    user_register_result_1 = User.register('oszust', 'password', 'kamil', 'email')
    expect(user_register_result_1).not_to be_nil
    user_register_result_2 = User.register('oszust', 'asdfr', 'kamil', 'email5')
    expect(user_register_result_2).to be_nil
  end

  it 'old password should be invalid' do
    old_password = 'oldPass'
    new_password = 'newPass'
    user = create(:user, password: old_password)
    User.change_password(user.id, old_password, new_password)
    expect(User.login(user.nick, old_password)).to be_nil
    expect(User.login(user.nick, new_password)).not_to be_nil
  end
end
