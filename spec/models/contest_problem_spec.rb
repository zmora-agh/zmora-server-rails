require 'rails_helper'

RSpec.describe ContestProblem, type: :model do

  # wszystkie submity do tego proglemu, które może oglądac dany prowadzący (od jkego podopiecznych)
  # def results(owner_id)
  #   results = []
  #   contest.contest_participations.where(contest_owner_id: owner_id).find_each do |participation|
  #     submit = submits.order(status: :asc, created_at: :desc).find_by(author: participation.user)
  #     results.push(submit) if submit
  #   end
  #   results
  # end

  describe '#results' do
    before(:each) do

# values are arrays. Allows to store multiple values for tha same key
      @submit_map = Hash.new {|hsh, key| hsh[key] = []}

      @contest_problem = create(:contest_problem)
      @contest = @contest_problem.contest

      @mentor1 = create(:user)
      @mentor2 = create(:user)

      @part1 = create(:contest_participation, contest: @contest, contest_owner: @mentor1)
      @part2 = create(:contest_participation, contest: @contest, contest_owner: @mentor1, create_ownership: false)
      @part3 = create(:contest_participation, contest: @contest, contest_owner: @mentor2)

      @participations = [@part1, @part2, @part3]

      for i in 1..10
        create_submit(@participations.sample, @contest_problem)
      end
    end

    it{
      expect(@contest_problem.results(@mentor1.id)).to match_array @submit_map[@mentor1.id]
      # expect(@contest_problem.results(@mentor2.id)).to match_array @submit_map[@mentor2.id]

    }
  end


  def create_submit(participation, problem)
    submit = create(:submit, contest_problem: problem, author: participation.user)
    @submit_map[participation.contest_owner.id].push submit

  end


end
