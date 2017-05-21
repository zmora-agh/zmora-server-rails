class GraphqlController < ApplicationController
  before_action :authenticate_request!

  def query
    result = Schema.execute(params[:query], variables: params[:variables], context: @current_user)
    render json: result
  end
end
