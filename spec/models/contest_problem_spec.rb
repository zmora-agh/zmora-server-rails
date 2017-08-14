require 'rails_helper'

RSpec.describe ContestProblem, type: :model do
  describe '#results' do
    before(:each) do
      @contest_problem = create(:contest_problem)
      @contest = @contest_problem.contest

      @mentor1 = create(:user)

      @part1 = create(:contest_participation, contest: @contest, contest_owner: @mentor1)
      @status = { ok: 0, que: 1, err: 2 }

      submit11 = method(:create_submit).curry[@part1][@contest_problem]

      @newer = submit11.curry[@status[:ok]][Date.new(2017, 8, 10)]
      @older = submit11.curry[@status[:ok]][Date.new(2017, 8, 9)]
      @wrong = submit11.curry[@status[:err]][Date.new(2017, 8, 9)]
    end

    it 'should find only  newest submit with OK status from one user to one contest_problem' do
      expect(@contest_problem.results(@mentor1.id)).to contain_exactly @newer
    end
  end

  def create_submit(participation, problem, stat, created_at)
    create(:submit, contest_problem: problem, author: participation.user, status: stat, created_at: created_at)
  end
end
