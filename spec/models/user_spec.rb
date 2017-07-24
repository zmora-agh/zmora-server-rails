require 'rails_helper'

RSpec.describe User, type: :model do
  it {is_expected.to validate_presence_of(:nick)}
  it {is_expected.to validate_presence_of(:email)}
  it {is_expected.to validate_presence_of(:name)}

  it {is_expected.to validate_uniqueness_of(:nick).ignoring_case_sensitivity}
  it {is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity}

  it {is_expected.to have_many(:problems)}
  it {is_expected.to have_many(:contest_ownerships)}
  it {is_expected.to have_many(:owned_contests)}
  it {is_expected.to have_many(:joined_contests)}

  it "can't register 2 users with the same nick" do
    user_register_result_1 = User.register('oszust', 'password', 'kamil', 'email')
    expect(user_register_result_1).not_to be_nil
    user_register_result_2 = User.register('oszust', 'asdfr', 'kamil', 'email5')
    expect(user_register_result_2).to be_nil
  end

  describe '.change_password' do
    let(:old_password) {'oldPass'}
    let(:new_password) {'newPass'}
    let(:user) {create(:user, password: old_password)}

    before do
      User.change_password(user.id, old_password, new_password)
    end

    it "old password invalid " do
      expect(User.login(user.nick, old_password)).to be_nil
    end
    it " new password valid" do
      expect(User.login(user.nick, new_password)).not_to be_nil
    end
  end
end