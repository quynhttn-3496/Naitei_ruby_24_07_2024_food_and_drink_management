class Api::V1::ApplicationController < ActionController::API
  attr_reader :current_user
  private

  def encode_token payload
    JWT.encode(payload, "salt")
  end

  def decode_token
    auth_header = request.headers["Authorization"]
    return nil unless auth_header

    token = auth_header.split(" ")[1]
    begin
      JWT.decode(token, "salt", true, algorithm: "HS256")
    rescue JWT::DecodeError
      nil
    end
  end

  def authenticate_user
    decoded_token = decode_token
    user_id = decoded_token[0]["user_id"] if decoded_token
    @current_user = User.find_by(id: user_id) if user_id

    return if @current_user

    render json: {message: "Please log in"}, status: :unauthorized
  end
end
