require 'json_web_tokens'

class ApplicationController < ActionController::API
  protected

  def authenticate_request!
    @current_user = payload
    if @current_user
      Raven.user_context('id': @current_user['id'], 'username': @current_user['nick'])
    else
      Raven.user_context({})
    end
  end

  private

  def payload
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last
    JsonWebTokens.decode(token)[0]
  rescue
    return nil
  end
end
