require 'rails_helper'

describe Submit do
  describe '#in_contest_owned_by?(contest_owner_id)' do
    let(:participation) { create(:contest_participation) }
    let(:problem) { create(:contest_problem, contest: participation.contest) }
    let(:owner) { participation.contest_owner }
    let(:submit) { create(:submit, contest_problem: problem, author: participation.user) }

    it 'owner owns contest' do
      expect(submit.in_contest_owned_by?(owner.id)).to be true
    end
    # TODO: author does not own contest
    # todo owner who is not mentor to user does not own contest
  end

  describe '#author?' do
    let(:submit) { create(:submit) }
    let(:random_user) { create(:user) }
    it {
      is_expected.to satisfy do
        submit.author?(submit.author.id)
      end
    }
    it {
      is_expected.not_to satisfy do
        submit.author?(random_user.id)
      end
    }
  end
end
