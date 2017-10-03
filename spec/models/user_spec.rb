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

    context('name having Polish diacritics') do
      it 'registers name with lowercase letters' do
        expect(User.register(attrs[:nick], attrs[:password], 'zażółć gęślą jaźń', attrs[:email])).to be_truthy
      end
      it 'registers name with uppercase letters' do
        expect(User.register(attrs[:nick], attrs[:password], 'ZAŻÓŁĆ GĘŚLĄ JAŹŃ', attrs[:email])).to be_truthy
      end
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
    def setup_problem_with_user(contest_state, joined)
      contest = create(:contest, contest_state)
      contest_problem = create(:contest_problem, contest: contest)
      user = create(:user)
      create(:contest_participation, user: user, contest: contest) if joined
      [contest_problem.id, user.id]
    end

    def can_submit_to(contest_state, joined)
      problem_id, user_id = setup_problem_with_user(contest_state, joined)
      User.can_submit_to?(user_id, problem_id)
    end

    context 'contest before signup' do
      it "any user can't submit to problem in contest" do
        expect(can_submit_to(:before_signup, false)).to be false
      end
    end

    context 'contest in enrollment' do
      it "participant can't submit to problem in contest" do
        expect(can_submit_to(:in_enrolment, true)).to be false
      end
    end

    context 'contest in progress' do
      it 'participant can submit to problem in contest' do
        expect(can_submit_to(:in_progress, true)).to be true
      end

      it "outsider can't submit to contest" do
        problem_id, = setup_problem_with_user(:in_progress, true)
        outsider_id = create(:user).id
        expect(User.can_submit_to?(outsider_id, problem_id)).to be false
      end
    end

    context 'ended contest' do
      it "participant can't submit to problem in contest" do
        expect(can_submit_to(:ended, true)).to be false
      end
    end

    context 'problem after hard deadline' do
      it "participant can't submit solution" do
        contest_participation = create(:contest_participation)
        user = contest_participation.user
        dead_problem = create(:contest_problem, contest: contest_participation.contest, hard_deadline: Date.yesterday)
        alive_problem = create(:contest_problem, contest: contest_participation.contest, hard_deadline: Date.tomorrow)
        expect(User.can_submit_to?(user.id, dead_problem.id)).to be false
        expect(User.can_submit_to?(user.id, alive_problem.id)).to be true
      end
    end
  end
end
