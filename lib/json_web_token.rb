class JsonWebToken
  SECRET_KEY = Rails.application.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    begin
      body = JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")[0]
      HashWithIndifferentAccess.new(body)
    rescue JWT::ExpiredSignature
      puts "JWT expired"
      nil
    rescue JWT::DecodeError => e
      puts "JWT Decode error: #{e.message}" #
      nil
    end
  end
end
