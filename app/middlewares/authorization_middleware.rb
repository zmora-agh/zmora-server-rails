class ZmoraGraphqlError < GraphQL::ExecutionError
  def initialize(status, message)
    super(message)
    @status = status
    @message = message
  end

  def to_h
    {
      status: @status,
      message: @message
    }
  end
end

class ForbiddenError < ZmoraGraphqlError
  def initialize
    super(403, 'Forbidden')
  end
end

class UnauthorizedError < ZmoraGraphqlError
  def initialize
    super(401, 'Unauthorized')
  end
end

class AuthorizationMiddleware
  def call(parent_type, _parent_object, field_definition, _field_args, query_context)
    @ctx = query_context
    return yield if parent_type.introspection?
    return yield if validate_type(parent_type) && validate_field(field_definition)
    return UnauthorizedError.new unless logged_in
    ForbiddenError.new
  end

  private

  def logged_in
    @ctx['id']
  end

  def admin
    @ctx['admin']
  end

  def validate_field(field_definition)
    permit = field_definition.metadata[:permit]
    if permit == :logged_in && !logged_in
      false
    elsif permit == :admin && !admin
      false
    else
      true
    end
  end

  def validate_type(type)
    permit = type.metadata[:permit]
    if permit == :everyone
      true
    elsif permit == :logged_in && logged_in
      true
    elsif permit == :admin && admin
      true
    else
      false
    end
  end
end
