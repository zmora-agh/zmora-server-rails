require 'rails_helper'

describe Submit do
  #todo version where all owner match predicate
  # describe '#in_contest_owned_by?(contest_owner_id)' do
  #   let(:problem) {create(:contest_problem)}
  #   let(:ownership) {create(:contest_ownership, contest: problem.contest)}
  #   let(:owner) {ownership.owner}
  #   let(:submit) {create(:submit, contest_problem: problem)}
  #
  #   it 'owner owns contest' do
  #     expect(problem.contest.owners.include?(owner)).to be true
  #     expect(submit.in_contest_owned_by?(owner.id)).to be true
  #   end
  # end

  #todo version where only mentor matches predicate
  # describe '#in_contest_owned_by?(contest_owner_id)' do
  #   let(:participation) {create(:contest_participation)}
  #   let(:problem) {create(:contest_problem, contest: participation.contest)}
  #   let(:owner) {participation.contest_owner}
  #   let(:submit) {create(:submit, contest_problem: problem)}
  #
  #   before do
  #
  #     puts('before block')
  #     puts(participation.contest_owner.id)
  #     puts(owner.id)
  #     puts(submit.contest_problem.contest.owners.map {|o| o.id})
  #     puts(submit.contest_problem.contest.owners.map {|o| o.id})
  #     puts(problem.contest.owners.map {|o| o.id})
  #   end
  #
  #   it 'owner owns contest' do
  #     # expect(problem.contest.owners.include?(owner)).to be true
  #     expect(submit.contest_problem.contest.owners.map {|o| o.id}.include?(owner.id)).to be true
  #     # expect(submit.in_contest_owned_by?(owner.id)).to be true
  #     expect(submit.contest_problem.id).to eq(problem.id)
  #     expect(submit.contest_problem.contest.id).to eq(participation.contest.id)
  #   end
  # end

  describe '#author?' do
    let(:submit) {create(:submit)}
    let(:random_user) {create(:user)}
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