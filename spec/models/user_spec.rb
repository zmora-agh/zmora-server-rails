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
      expect(User.register(attrs[:nick], attrs[:password],
                           attrs[:name], attrs[:email])).not_to be_nil
      expect(User.register(attrs[:nick], attrs[:password],
                           attrs[:name], attrs[:email])).to be_nil
    end

    it "can't register user with password shorter than 8 characters" do
      expect(User.register(attrs[:nick], '', attrs[:name], attrs[:email])).to be_nil
      expect(User.register(attrs[:nick], 'XD', attrs[:name], attrs[:email])).to be_nil
      expect(User.register(attrs[:nick], 'XDDDDDD', attrs[:name], attrs[:email])).to be_nil
    end

    it "can't register user with invalid username" do
      expect(User.register('', attrs[:password], attrs[:name], attrs[:email])).to be_nil
      expect(User.register('żółciutki kwiatuszek', attrs[:password], attrs[:name], attrs[:email])).to be_nil
      expect(User.register('( ͡° ͜ʖ ͡°)', attrs[:password], attrs[:name], attrs[:email])).to be_nil
      expect(User.register('                ', attrs[:password], attrs[:name], attrs[:email])).to be_nil
    end

    it "can't register user with invalid e-mail" do
      expect(User.register(attrs[:nick], attrs[:password], attrs[:name], '')).to be_nil
      expect(User.register(attrs[:nick], attrs[:password], attrs[:name], 'user')).to be_nil
      expect(User.register(attrs[:nick], attrs[:password], attrs[:name], 'user@')).to be_nil
      expect(User.register(attrs[:nick], attrs[:password], attrs[:name], '          ')).to be_nil
    end

    it "can't register user with invalid name" do
      expect(User.register(attrs[:nick], attrs[:password], '', attrs[:email])).to be_nil
      expect(User.register(attrs[:nick], attrs[:password], '             ', attrs[:email])).to be_nil
      expect(User.register(attrs[:nick], attrs[:password], 'Александр Пистолетов', attrs[:email])).to be_nil
    end
  end

  describe '.change_password .login' do
    let(:old_password) { 'oldPass123' }
    let(:new_password) { 'newPass123' }
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

    before do
      create(:contest_ownership, owner: user, contest: contest)
    end

    it 'finds association with contest' do
      expect(User.owner_of?(user.id, contest.id)).to be true
    end
  end

  describe '.can_view_user_submits_in_problem?' do
    let(:contest_problem) { create(:contest_problem) }
    let(:contest_participations) { create(:contest_participation, contest: contest_problem.contest) }

    it 'contest owner can view participants results' do
      owner = contest_participations.contest_owner.id
      participant = contest_participations.user.id
      expect(
        User.can_view_user_submits_in_problem?(owner, participant, contest_problem)
      ).to be true
      # TODO: participant can view
      # todo random user can't view
    end
  end

  describe '.can_submit_to?' do
    let(:contest_problem) { create(:contest_problem) }
    let(:contest_participations) { create(:contest_participation, contest: contest_problem.contest) }

    it 'participant can submit to problem when contest is in progress' do
      participant = contest_participations.user.id
      expect(
        User.can_submit_to?(participant, contest_problem.id)
      ).to be true
      # TODO: can't submit  when not in progress
    end
  end
end
