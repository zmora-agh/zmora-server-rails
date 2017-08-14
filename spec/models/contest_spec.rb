require 'rails_helper'

RSpec.describe Contest, type: :model do
  let(:ownership) { create(:contest_ownership) }
  let(:valid_password) { ownership.join_password }
  let(:contest) { ownership.contest }
  let(:user) { create(:user) }

  describe '.join' do
    it 'user can join if submitted password is valid for contest' do
      expect(Contest.join(user.id, contest.id, valid_password)).not_to be nil
    end

    it "user can't join if password invalid" do
      invalid_password = 'dflgjkngkllknrfg'
      expect(Contest.join(user.id, contest.id, invalid_password)).to be nil
    end

    describe ' user can only join in signup time' do
      pending 'feature not yet implemented'
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
        random_contest = create(:contest)
        expect(random_contest.user_participates?(user.id)).not_to be true
      end
    end
  end

  describe '#in_progress?' do
    context 'when before_signup' do
      it { expect(create(:contest, start: Date.tomorrow)).not_to be_in_progress }
    end

    context 'when ended' do
      it { expect(create(:contest, in_progress: false)).not_to be_in_progress }
    end

    context 'in progress' do
      it { expect(create(:contest)).to be_in_progress }
    end
  end
end
