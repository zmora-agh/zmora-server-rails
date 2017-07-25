require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of(:nick) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to validate_uniqueness_of(:nick).ignoring_case_sensitivity }
  it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }

  it { is_expected.to have_many(:problems) }
  it { is_expected.to have_many(:contest_ownerships) }
  it { is_expected.to have_many(:owned_contests) }
  it { is_expected.to have_many(:joined_contests) }

  describe '.register' do
    let(:attrs) { attributes_for(:user) }
    it "can't register 2 users with the same nick/email" do
      expect(User.register(*attrs)).not_to be_nil
      expect(User.register(*attrs)).to be_nil
    end
  end

  describe '.change_password' do
    let(:old_password) { 'oldPass' }
    let(:new_password) { 'newPass' }
    let(:user) { create(:user, password: old_password) }

    before do
      User.change_password(user.id, old_password, new_password)
    end

    it 'old password invalid ' do
      expect(User.login(user.nick, old_password)).to be_nil
    end

    it ' new password valid' do
      expect(User.login(user.nick, new_password)).not_to be_nil
    end
  end

  describe '.owner_of?' do
    let(:user) { create(:user) }
    let(:contest) { create(:contest) }
    let(:contest_ownership) { create(:contest_ownership, owner: user, contest: contest) }

    before do
      user.contest_ownerships << contest_ownership
    end

    it 'finds association with contest' do
      expect(User.owner_of?(user.id, contest.id)).to be true
    end
  end
end
