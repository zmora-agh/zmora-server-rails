UserType = GraphQL::ObjectType.define do
  name 'User'
  description 'Zmora user'

  field :id, !types.ID
  field :nick, !types.String
  field :email, !types.String
  field :name, !types.String
end

QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'The root of all queries'

  field :users do
    type types[UserType]
    description 'All users registered to zmora'
    resolve -> (obj, args, ctx) { User.all }
  end
end

Schema = GraphQL::Schema.define do
  query QueryType
end
