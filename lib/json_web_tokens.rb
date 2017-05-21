require 'jwt'

class JsonWebTokens # :nodoc:
  def self.encode(payload)
    JWT.encode payload, Rails.application.secrets.secret_key_base, 'HS256'
  end

  def self.decode(token)
    JWT.decode token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256'
  end
end
