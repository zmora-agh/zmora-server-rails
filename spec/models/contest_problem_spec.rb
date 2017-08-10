require 'rails_helper'

RSpec.describe ContestProblem, type: :model do
  describe '#results' do
    before(:each) do

      # values are arrays. Allows to store multiple values for tha same key
      @submit_map = Hash.new {|hsh, key| hsh[key] = []}

      @contest_problem = create(:contest_problem)
      @contest = @contest_problem.contest

      @mentor1 = create(:user)

      @part1 = create(:contest_participation, contest: @contest, contest_owner: @mentor1)

      create_submit(@part1, @contest_problem)
      create_submit(@part1, @contest_problem)

      #debugging
      puts("mentor #{@mentor1.id}")
      puts("paticipation: user: #{@part1.user.id}, mentor: #{@part1.contest_owner.id}")
      @submit_map[@part1.contest_owner.id].map {|s| puts("id:#{s.id} , author: #{s.author.id} , problem:#{s.contest_problem.id}")}

    end

    it 'should find multiple submits from one user to one contest_problem' do
      expect(@contest_problem.results(@mentor1.id)).to match_array @submit_map[@mentor1.id]

    end
  end

  # helper methods
  def create_submit(participation, problem)
    submit = create(:submit, contest_problem: problem, author: participation.user)
    @submit_map[participation.contest_owner.id].push submit
  end

end
