require 'rails_helper'

RSpec.describe Contest, type: :model do
  let(:user) { create(:user) }

  def setup_contest(trait = nil)
    contest = create(:contest, trait)
    contest_ownership = create(:contest_ownership, contest: contest)
    [contest, contest_ownership.join_password]
  end

  def join_with_valid_password(trait = nil)
    contest, password = setup_contest(trait)
    Contest.join(user.id, contest.id, password)
  end

  def join_with_invalid_password(trait = nil)
    contest, password = setup_contest(trait)
    invalid_password = password + 'invalidated'
    Contest.join(user.id, contest.id, invalid_password)
  end

  describe '.join' do
    it "user can't join with invalid password" do
      expect(join_with_invalid_password).to be_nil
    end

    context 'ended contest' do
      it 'fails to join' do
        expect(join_with_valid_password(:ended)).to be_nil
        expect(join_with_invalid_password(:ended)).to be_nil
      end
    end

    context 'contest before signup' do
      it 'fails to join' do
        expect(join_with_valid_password(:before_signup)).to be_nil
        expect(join_with_invalid_password(:before_signup)).to be_nil
      end
    end

    context 'locked (non-joinable in progress) contest' do
      it 'fails to join' do
        expect(join_with_valid_password(:in_progress_locked)).to be_nil
        expect(join_with_invalid_password(:in_progress_locked)).to be_nil
      end
    end

    context 'unlocked (joinable in progress) contest' do
      it 'succeeds to join' do
        expect(join_with_valid_password(:in_progress_unlocked)).to be true
        expect(join_with_invalid_password(:in_progress_unlocked)).to be_nil
      end
    end
  end

  describe '#user_participates?' do
    describe 'after joining contest ' do
      let(:contest) do
        contest, password = setup_contest(:in_enrolment)
        Contest.join(user.id, contest.id, password)
        contest
      end

      it '.user_participates? is fulfilled on this contest' do
        expect(contest.user_participates?(user.id)).to be true
      end

      it '.user_participates? is not fulfilled on some random contest' do
        random_contest = create(:contest, :in_progress)
        expect(random_contest.user_participates?(user.id)).not_to be true
      end
    end
  end

  context 'before signup' do
    let(:contest_before_signup) { create(:contest, :before_signup) }
    it { expect(contest_before_signup).not_to be_started }
    it { expect(contest_before_signup).not_to be_in_enrolment }
    it { expect(contest_before_signup).not_to be_in_progress }
  end

  context 'in enrolment' do
    let(:contest_in_enrolment) { create(:contest, :in_enrolment) }
    it { expect(contest_in_enrolment).not_to be_started }
    it { expect(contest_in_enrolment).to be_in_enrolment }
    it { expect(contest_in_enrolment).not_to be_in_progress }
  end

  context 'in progress' do
    let(:contest_in_progress) { create(:contest) }
    it { expect(contest_in_progress).to be_started }
    it { expect(contest_in_progress).not_to be_in_enrolment }
    it { expect(contest_in_progress).to be_in_progress }
  end

  context 'ended' do
    let(:contest_ended) { create(:contest, :ended) }
    it { expect(contest_ended).to be_started }
    it { expect(contest_ended).not_to be_in_enrolment }
    it { expect(contest_ended).not_to be_in_progress }
  end

  def get_signup_password(contest)
    ownership = create(:contest_ownership, contest: contest)
    ownership.join_password
  end
end
