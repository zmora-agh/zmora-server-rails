require 'rails_helper'

describe Submit do
  let(:participation) { create(:contest_participation) }
  let(:contest) { participation.contest }
  let(:owner) { participation.contest_owner }
  let(:second_owner) { create(:contest_ownership, contest: participation.contest).owner }

  describe '#in_contest_owned_by?' do
    subject(:submit) do
      problem = create(:contest_problem, contest: participation.contest)
      create(:submit, contest_problem: problem, author: participation.user)
    end

    it 'owner owns contest' do
      is_expected.to be_in_contest_owned_by(owner.id)
    end

    it 'author does not own contest' do
      is_expected.not_to be_in_contest_owned_by(submit.author.id)
    end

    it 'owner who is not mentor to submit author does not own contest' do
      is_expected.not_to be_in_contest_owned_by(second_owner.id)
    end
  end

  describe '#author?' do
    subject(:submit) { create(:submit) }

    it 'author of submit: true' do
      legit_user = submit.author
      is_expected.to be_author(legit_user.id)
    end

    it 'random user: false' do
      random_user = create(:user)
      is_expected.not_to be_author(random_user.id)
    end
  end

  describe '#contest_solutions' do
    let(:participant) { participation.user }
    let(:contest_problem) { create(:contest_problem, contest: participation.contest) }

    def contest_solutions(contest_owner = owner)
      Submit.contest_solutions(participation.contest.id, contest_owner.id)
    end

    def add_participant(contest_owner = owner)
      create(:contest_participation, contest: contest, contest_owner: contest_owner).user
    end

    context('with contest without solutions') do
      it { expect(contest_solutions).to be_empty }
    end

    context('with problem with one valid submit') do
      it 'should have single attempt solution' do
        create(:submit, contest_problem: contest_problem, author: participant)
        expect(contest_solutions).to eq([{ user: participant,
                                           solutions: [{ problem: contest_problem, attempts: 1 }] }])
      end
    end

    it 'lists users without any solved problems' do
      create(:submit, author: participant, contest_problem: contest_problem, status: :err)
      create(:submit, author: participant, contest_problem: contest_problem, status: :err)
      create(:submit, author: participant, contest_problem: contest_problem, status: :err)
      create(:submit, author: participant, contest_problem: contest_problem, status: :que)

      expect(contest_solutions(owner)).to eq([{ user: participant, solutions: [] }])
    end

    it 'distinguishes other tutors contest instances' do
      second_owner_participant = add_participant(second_owner)
      create(:submit, author: participant, contest_problem: contest_problem, status: :ok)
      create(:submit, author: second_owner_participant, contest_problem: contest_problem, status: :ok)

      expect(contest_solutions(owner)).to have_exactly(1).item
      expect(contest_solutions(second_owner)).to have_exactly(1).items
    end

    it 'counts attempt till first successful submit' do
      create(:submit, author: participant, contest_problem: contest_problem, status: :err, created_at: 5.days.ago)
      create(:submit, author: participant, contest_problem: contest_problem, status: :ok, created_at: 4.days.ago)
      # After first succeeded submit the all following are not assumed as an attempt
      create(:submit, author: participant, contest_problem: contest_problem, status: :err, created_at: 3.days.ago)
      create(:submit, author: participant, contest_problem: contest_problem, status: :ok, created_at: 2.days.ago)
      create(:submit, author: participant, contest_problem: contest_problem, status: :que, created_at: 1.day.ago)

      expect(contest_solutions).to have_exactly(1).item
      expect(contest_solutions[0][:solutions]).to have_exactly(1).item
      expect(contest_solutions[0][:solutions][0][:attempts]).to eq(2)
    end

    it 'aggregates multiple problems per user' do
      second_problem = create(:contest_problem, contest: contest)
      create(:submit, author: participant, contest_problem: contest_problem, status: :ok)
      create(:submit, author: participant, contest_problem: second_problem, status: :ok)

      expect(contest_solutions).to have_exactly(1).item
      expect(contest_solutions[0][:solutions]).to have_exactly(2).items
      expect(contest_solutions[0][:solutions][0][:attempts]).to eq(1)
      expect(contest_solutions[0][:solutions][1][:attempts]).to eq(1)
    end

    it 'distinguishes different users in single problem' do
      second_participant = add_participant(owner)
      create(:submit, author: participant, contest_problem: contest_problem, status: :ok)
      create(:submit, author: second_participant, contest_problem: contest_problem, status: :ok)

      expect(contest_solutions).to have_exactly(2).items
      expect(contest_solutions[0][:solutions][0][:attempts]).to eq(1)
      expect(contest_solutions[1][:solutions][0][:attempts]).to eq(1)
    end

    it 'sorts problems in order: required then optional, created_at' do
      later_optional_problem = create(:contest_problem, contest: contest, required: false, created_at: 2.days.ago)
      create(:submit, author: participant, contest_problem: later_optional_problem)

      earlier_required_problem = create(:contest_problem, contest: contest, required: true, created_at: 3.days.ago)
      create(:submit, author: participant, contest_problem: earlier_required_problem)

      earlier_optional_problem = create(:contest_problem, contest: contest, required: false, created_at: 4.days.ago)
      create(:submit, author: participant, contest_problem: earlier_optional_problem)

      later_required_problem = create(:contest_problem, contest: contest, required: true, created_at: 1.day.ago)
      create(:submit, author: participant, contest_problem: later_required_problem)

      expect(contest_solutions).to eq([
                                        { user: participant, solutions: [
                                          { problem: earlier_required_problem, attempts: 1 },
                                          { problem: later_required_problem, attempts: 1 },
                                          { problem: earlier_optional_problem, attempts: 1 },
                                          { problem: later_optional_problem, attempts: 1 }
                                        ] }
                                      ])
    end
  end
end
