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
end
