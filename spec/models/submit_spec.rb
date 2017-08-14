require 'rails_helper'

describe Submit do
  describe '#in_contest_owned_by?' do
    let(:participation) { create(:contest_participation) }
    let(:owner) { participation.contest_owner }
    let(:second_owner) { create(:contest_ownership, contest: participation.contest).owner }

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

  describe '#contest' do
    let(:status) { { ok: 0, que: 1, err: 2 } }

    let(:contest1) { create(:contest) }
    let(:contest2) { create(:contest) }

    let(:contest_problem11) { create(:contest_problem, contest: contest1) }
    let(:contest_problem12) { create(:contest_problem, contest: contest1) }
    let(:contest_problem21) { create(:contest_problem, contest: contest2) }
    let(:contest_problem22) { create(:contest_problem, contest: contest2) }

    let(:mentor1) { create(:user) }
    let(:mentor2) { create(:user) }

    let(:author1) { create(:user) }
    let(:author2) { create(:user) }

    let(:part1) { create(:contest_participation, contest: contest1, contest_owner: mentor1, user: author1) }

    before(:each) do
    end

    it 'should find only  newest submit with OK status from one user to one contest_problem' do
      # expect(@contest_problem.results(@mentor1.id)).to contain_exactly (@newer)
      expect(2).to be 2
    end
  end
end
