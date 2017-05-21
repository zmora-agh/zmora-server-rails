require 'json_web_tokens'

class ApplicationController < ActionController::API
  protected

  def authenticate_request!
    @current_user = payload
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
