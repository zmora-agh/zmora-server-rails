# coding: utf-8

GraphQL::Field.accepts_definitions permit: GraphQL::Define.assign_metadata_key(:permit)
GraphQL::ObjectType.accepts_definitions permit: GraphQL::Define.assign_metadata_key(:permit)

UserType = GraphQL::ObjectType.define do
  name 'User'
  description 'Zmora user'
  permit :logged_in

  field :id, !types.Int

  field :about, !types.String
  field :email, !types.String
  field :name, !types.String
  field :nick, !types.String
end

SubmitFileType = GraphQL::ObjectType.define do
  name 'SubmitFile'
  permit :logged_in

  field :id, !types.Int
  field :url do
    type !types.String
    resolve ->(obj, _args, _ctx) { obj.file.url }
  end

  field :checksum, !types.String, property: :file_fingerprint
  field :filename, !types.String, property: :file_file_name
end

AnswerType = GraphQL::ObjectType.define do
  name 'Answer'
  permit :logged_in

  field :id, !types.Int

  field :answer, !types.String
  field :author, !UserType
  field :answered, !types.String, property: :created_at
end

ExampleType = GraphQL::ObjectType.define do
  name 'Example'
  permit :logged_in

  field :id, !types.Int

  field :explanation, !types.String
  field :input, !types.String
  field :number, !types.Int
  field :result, !types.String
end

TestResultType = GraphQL::ObjectType.define do
  name 'TestResult'
  permit :logged_in

  field :id, !types.Int

  field :executionTime, !types.Int, property: :user_time
  field :ramUsage, !types.Int, property: :ram_usage
  field :status, !types.String
  field :test, !types.Int, property: :test_id
end

SubmitType = GraphQL::ObjectType.define do
  name 'Submit'
  permit :logged_in

  field :id, !types.Int

  field :author, !UserType
  field :date, !types.String, property: :created_at
  field :status, !types.String
  field :submitFiles, types[SubmitFileType], property: :submit_files
  field :testResults, types[TestResultType], property: :test_results
end

QuestionType = GraphQL::ObjectType.define do
  name 'Question'
  permit :logged_in

  field :id, !types.Int

  field :answers, types[AnswerType]
  field :asked, !types.String, property: :created_at
  field :author, !UserType
  field :question, !types.String
end

ProblemType = GraphQL::ObjectType.define do # rubocop:disable Metrics/BlockLength
  name 'Problem'
  permit :logged_in

  field :id, !types.Int
  field :basePoints, !types.Int, property: :base_points
  field :category, !types.String
  field :examples do
    type types[ExampleType]
    resolve ->(obj, _args, _ctx) { obj.problem.examples }
  end
  field :description do
    type !types.String
    resolve ->(obj, _args, _ctx) { obj.problem.description }
  end
  field :hardDeadline, !types.String, property: :hard_deadline
  field :name do
    type !types.String
    resolve ->(obj, _args, _ctx) { obj.problem.name }
  end
  field :required, !types.Boolean
  field :shortcode, !types.String
  field :softDeadline, !types.String, property: :soft_deadline
  field :submits, types[SubmitType] do
    argument :user_id, types.Int
    resolve(lambda do |obj, args, ctx|
      id = args[:user_id] ? args[:user_id] : ctx['id']
      return [] unless User.can_view_user_submits_in_problem?(ctx['id'], id, obj)
      obj.submits.where(author_id: id)
    end)
  end
  field :questions, types[QuestionType]
  field :results, types[SubmitType] do
    description 'Agregates all submits in problem and shows best for each user'
    resolve ->(obj, _args, ctx) { obj.results(ctx['id']) if User.owner_of?(ctx['id'], obj.contest.id) }
  end
end

ProblemSolutionType = GraphQL::ObjectType.define do
  name 'ProblemSolution'
  permit :logged_in

  field :problem, !ProblemType, hash_key: :problem
  field :attempts, !types.Int, hash_key: :attempts
end

ContestAttemptType = GraphQL::ObjectType.define do
  name 'ContestRanking'
  permit :logged_in

  field :user, !UserType, hash_key: :user
  field :solutions, !types[ProblemSolutionType], hash_key: :solutions
end

ContestSubmitMetricsType = GraphQL::ObjectType.define do
  name 'ContestSubmitMetrics'
  permit :logged_in
  field :status, !types.String, hash_key: :status
  field :submits, !types.Int, hash_key: :submits
end

ContestType = GraphQL::ObjectType.define do # rubocop:disable Metrics/BlockLength
  name 'Contest'
  permit :logged_in

  field :id, !types.Int

  field :description, !types.String
  field :duration, !types.Int
  field :joined do
    type !types.Boolean
    resolve ->(obj, _args, ctx) { ContestParticipation.exists?(contest_id: obj.id, user_id: ctx['id']) }
  end
  field :name, !types.String
  field :signupDuration, !types.Int, property: :signup_duration
  field :start, !types.String
  field :canJoinStarted, !types.Boolean, property: :can_join_started
  field :owners, types[UserType]
  field :ranking do
    type !types[ContestAttemptType]
    resolve(lambda do |obj, _args, ctx|
      Submit.contest_solutions(obj.id, ctx['id'])
    end)
  end
  field :submitMetrics do
    type types[ContestSubmitMetricsType]
    resolve ->(obj, _args, ctx) { obj.submit_metrics(ctx['id']) if User.owner_of?(ctx['id'], obj.id) }
  end
  field :problems do
    type types[ProblemType]
    resolve(lambda do |obj, _args, ctx|
      result = obj.contest_problems
      return result if User.can_access_contest_problems?(ctx['id'], obj)
      []
    end)
  end
end

QueryType = GraphQL::ObjectType.define do # rubocop:disable Metrics/BlockLength
  name 'Query'
  description 'The root of all queries'
  permit :everyone

  field :users do
    permit :admin
    type types[UserType]
    description 'All users registered to zmora'
    resolve ->(_obj, _args, _ctx) { User.all }
  end

  field :contests do
    permit :logged_in
    type types[ContestType]
    resolve ->(_obj, _args, _ctx) { Contest.all }
  end

  field :contest do
    type ContestType
    argument :id, !types.Int
    resolve ->(_obj, args, _ctx) { Contest.find_by(id: args[:id]) }
  end

  field :problem do
    type ProblemType
    argument :id, !types.Int
    resolve(lambda do |_obj, args, ctx|
      problem = ContestProblem.find_by(id: args[:id])
      problem if User.can_access_contest_problems?(ctx['id'], problem&.contest)
    end)
  end

  field :submit do
    type SubmitType
    argument :id, !types.Int
    resolve(lambda do |_obj, args, ctx|
      submit = Submit.find_by(id: args[:id])
      submit if submit && submit.author?(ctx['id']) || submit.in_contest_owned_by?(ctx['id'])
    end)
  end

  field :time do
    type !types.String
    permit :everyone
    resolve ->(_obj, _args, _ctx) { Time.current }
  end
end

MutationType = GraphQL::ObjectType.define do # rubocop:disable Metrics/BlockLength
  name 'Mutation'
  description 'The root of all mutations'
  permit :everyone

  field :getJwtToken do
    type types.String
    description 'Returns JWT token for user'
    argument :nick, !types.String
    argument :password, !types.String
    resolve ->(_obj, args, _ctx) { User.login(args[:nick], args[:password]) }
  end

  field :register do
    type types.String
    description 'Registers new user'
    argument :nick, !types.String
    argument :password, !types.String
    argument :name, !types.String
    argument :email, !types.String
    resolve ->(_obj, args, _ctx) { User.register(args[:nick], args[:password], args[:name], args[:email]) }
  end

  field :joinContest, ContestType do
    permit :logged_in
    description 'Joins a contest'
    argument :id, !types.Int
    argument :password, !types.String
    resolve(lambda do |_obj, args, ctx|
      begin
        Contest.join(ctx['id'], args[:id], args[:password]) ? Contest.find_by(id: args[:id]) : nil
      rescue ArgumentError
        return ZmoraGraphqlError.new(400, 'User is already participating in the contest')
      end
    end)
  end

  field :changePassword, !types.Boolean do
    permit :logged_in
    description 'Changes logged user password'
    argument :oldPassword, !types.String
    argument :newPassword, !types.String
    resolve ->(_obj, args, ctx) { User.change_password(ctx['id'], args[:oldPassword], args[:newPassword]) }
  end
end

Schema = GraphQL::Schema.define do
  query QueryType
  mutation MutationType
  middleware AuthorizationMiddleware.new
  Rails.configuration.graphite_uri && instrument(:query, GraphiteInstrumentation)
end
