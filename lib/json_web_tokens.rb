require 'jwt'

class JsonWebTokens # :nodoc:
  def self.encode(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end
end
