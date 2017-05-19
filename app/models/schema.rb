# coding: utf-8
UserType = GraphQL::ObjectType.define do
  name 'User'
  description 'Zmora user'

  field :id, !types.ID

  field :about, !types.String
  field :email, !types.String
  field :name, !types.String
  field :nick, !types.String
end

SubmitFileType = GraphQL::ObjectType.define do
  name 'SubmitFile'

  field :id, !types.ID

  field :checksum, !types.String
  field :filename do
    type !types.String
    resolve -> (obj, args, ctx) { obj.file_file_name }
  end
end

AnswerType = GraphQL::ObjectType.define do
  name 'Answer'

  field :id, !types.ID

  field :answer, !types.String
  field :author do
    type !UserType
    resolve -> (obj, args, ctx) { obj.author }
  end
  field :answered do
    type !types.String
    resolve -> (obj, args, ctx) { obj.created_at }

  end
end

ExampleType = GraphQL::ObjectType.define do
  name 'Example'

  field :id, !types.ID

  field :explanation, !types.String
  field :input, !types.String
  field :number, !types.Int
  field :result, !types.String
end

TestResultType = GraphQL::ObjectType.define do
  name 'TestResult'

  field :id, !types.ID

  field :execution_time, !types.Int
  field :ram_usage, !types.Int
  field :status, !types.String
end

SubmitType = GraphQL::ObjectType.define do
  name 'Submit'

  field :id, !types.ID

  field :author, !UserType
  field :date do
    type !types.String
    resolve -> (obj, args, ctx) { obj.created_at }
  end
  field :status, !types.String
  field :submit_files, types[SubmitFileType]
  field :test_results, types[TestResultType]
end

QuestionType = GraphQL::ObjectType.define do
  name 'Question'

  field :id, !types.ID

  field :answers, types[AnswerType]
  field :asked do
    type !types.String
    resolve -> (obj, args, ctx) { obj.created_at }
  end
  field :author, !UserType
  field :question, !types.String
end

ProblemType = GraphQL::ObjectType.define do
  name 'Problem'

  field :id, !types.ID

  field :base_points, !types.Int
  field :category, !types.String
  field :examples do
    type types[ExampleType]
    resolve -> (obj, args, ctx) { obj.problem.examples }
  end
  field :description do
    type !types.String
    resolve -> (obj, args, ctx) { obj.problem.description }
  end
  field :hard_deadline, !types.String
  field :name do
    type !types.String
    resolve -> (obj, args, ctx) { obj.problem.name }
  end
  field :required, !types.Boolean
  field :shortcode, !types.String
  field :soft_deadline, !types.String
  field :submits do
    type types[SubmitType]
    resolve -> (obj, args, ctx) { obj.submits }
  end
  field :questions do
    type types[QuestionType]
    resolve -> (obj, args, ctx) { obj.questions }
  end
end

ContestType = GraphQL::ObjectType.define do
  name 'Contest'

  field :id, !types.ID

  field :description, !types.String
  field :duration, !types.Int
  field :joined do
    type !types.Boolean
    resolve -> (obj, args, ctx) { true }
  end
  field :name, !types.String
  field :signupDuration, !types.Int
  field :start, !types.String
  field :owners do
    type types[UserType]
    resolve -> (obj, args, ctx) { obj.owners }
  end
  field :problems do
    type types[ProblemType]
    resolve -> (obj, args, ctx) { obj.contest_problems }
  end
end

QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'The root of all queries'

  field :users do
    type types[UserType]
    description 'All users registered to zmora'
    resolve -> (obj, args, ctx) { User.all }
  end

  field :contests do
    type types[ContestType]
    resolve -> (obj, args, ctx) { Contest.all }
  end
end

Schema = GraphQL::Schema.define do
  query QueryType
end
