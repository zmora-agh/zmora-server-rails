# coding: utf-8
UserType = GraphQL::ObjectType.define do
  name 'User'
  description 'Zmora user'

  field :id, !types.ID

  field :email, !types.String
  field :name, !types.String
  field :nick, !types.String
end

SubmitFileType = GraphQL::ObjectType.define do
  name 'SubmitFile'

  field :id, !types.ID

  field :checksum, !types.String
  field :filename, !types.String
end

AnswerType = GraphQL::ObjectType.define do
  name 'Answer'

  field :id, !types.ID

  field :answer, !types.String
  field :author, !UserType
  field :answered, !types.String
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

  field :executionTime, !types.Int
  field :ramUsage, !types.Int
  field :status, !types.String
end

SubmitType = GraphQL::ObjectType.define do
  name 'Submit'

  field :id, !types.ID

  field :author, !UserType
  field :date, !types.String
  field :status, !types.String
  field :submitFiles, types[SubmitFileType]
  field :testResults, types[TestResultType]
end

QuestionType = GraphQL::ObjectType.define do
  name 'Question'

  field :id, !types.ID

  field :answers, types[AnswerType]
  field :asked, !types.String
  field :author, !UserType
  field :question, !types.String
end

ProblemType = GraphQL::ObjectType.define do
  name 'Problem'

  field :id, !types.ID

  field :basePoints, !types.Int
  field :category, !types.String
  field :examples, types[ExampleType]
  field :description, !types.String
  field :hardDeadline, !types.String
  field :name, !types.String
  field :required, !types.Boolean
  field :shortcode, !types.String
  field :softDeadline, !types.String
  field :submits, types[SubmitType]
  field :questions, types[QuestionType]
end

ContestType = GraphQL::ObjectType.define do
  name 'Contest'

  field :id, !types.ID

  field :description, !types.String
  field :duration, !types.Int
  field :joined, !types.Boolean
  field :name, !types.String
  field :signupDuration, !types.Int
  field :start, !types.String
  field :owners, types[UserType]
  field :problems, types[ProblemType]
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
    resolve -> (obj, args, ctx) { Contests.all }
  end
end

Schema = GraphQL::Schema.define do
  query QueryType
end
