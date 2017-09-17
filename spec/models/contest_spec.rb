require 'rails_helper'

RSpec.describe Contest, type: :model do
  let(:contest) { create(:contest, :in_enrolment) }
  let(:user) { create(:user) }
  let(:valid_password) { get_signup_password(contest) }

  describe '.join' do
    it 'user can join only if submitted password is valid for contest' do
      invalid_password = 'dflgjkngkllknrfg'
      expect(Contest.join(user.id, contest.id, valid_password)).not_to be nil
      expect(Contest.join(user.id, contest.id, invalid_password)).to be nil
    end

    it ' user can only join in signup time, when can_join_started == false' do
      contest_with_valid_signup_time = create(:contest, :in_enrolment)
      contest_in_progress = create(:contest, :in_progress)
      contest_before_signup_time = create(:contest, :before_signup)
      contest_ended = create(:contest, :ended)
      expect(Contest.join(user.id, contest_with_valid_signup_time.id,
                          get_signup_password(contest_with_valid_signup_time))).to be true
      expect(Contest.join(user.id, contest_in_progress.id,
                          get_signup_password(contest_in_progress))).to be nil
      expect(Contest.join(user.id, contest_before_signup_time.id,
                          get_signup_password(contest_before_signup_time))).to be nil
      expect(Contest.join(user.id, contest_ended.id,
                          get_signup_password(contest_ended))).to be nil
    end

    it ' user can only join in signup time and when contest is in progress, when can_join_started == true' do
      contest_with_valid_signup_time = create(:contest, :in_enrolment, can_join_started: true)
      contest_in_progress = create(:contest, :in_progress, can_join_started: true)
      contest_before_signup_time = create(:contest, :before_signup, can_join_started: true)
      contest_ended = create(:contest, :ended, can_join_started: true)
      expect(Contest.join(user.id, contest_with_valid_signup_time.id,
                          get_signup_password(contest_with_valid_signup_time))).to be true
      expect(Contest.join(user.id, contest_in_progress.id,
                          get_signup_password(contest_in_progress))).to be true
      expect(Contest.join(user.id, contest_before_signup_time.id,
                          get_signup_password(contest_before_signup_time))).to be nil
      expect(Contest.join(user.id, contest_ended.id,
                          get_signup_password(contest_ended))).to be nil
    end
  end

  describe '#user_participates?' do
    describe 'after joining contest ' do
      before do
        Contest.join(user.id, contest.id, valid_password)
      end

      it '.user_participates? is fulfilled on this contest' do
        expect(contest.user_participates?(user.id)).to be true
      end

      it '.user_participates? is  not fulfilled on some random contest' do
        random_contest = create(:contest, :in_progress)
        expect(random_contest.user_participates?(user.id)).not_to be true
      end
    end
  end

  describe '#in_progress?' do
    context 'when before_signup' do
      it { expect(create(:contest, :before_signup)).not_to be_in_progress }
    end

    context 'when ended' do
      it { expect(create(:contest, :ended)).not_to be_in_progress }
    end

    context 'in progress' do
      it { expect(create(:contest, :in_progress)).to be_in_progress }
    end
  end

  def get_signup_password(contest)
    ownership = create(:contest_ownership, contest: contest)
    ownership.join_password
  end
end
