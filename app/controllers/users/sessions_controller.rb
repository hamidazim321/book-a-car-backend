# frozen_string_literal: true
class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json

  private

  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      token = request.headers['Authorization'].split(' ').last
      jwt_payload = decode_jwt(token)

      if jwt_payload.present? && jwt_payload.key?('jti')
        current_user = User.find_by(jti: jwt_payload['jti'])
      end
    end

    if current_user
      render json: {
        status: 200,
        message: 'Logged out successfully.'
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end

  def decode_jwt(token)
    begin
      JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256').first
    rescue JWT::DecodeError => e
      # Handle the error, e.g., log it or return nil
      Rails.logger.error("JWT Decode Error: #{e.message}")
      nil
    end
  end
end
