# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(_resource, _options = {})
    render json: {
      status: { code: 200, message: 'User logged in successfully.',
                data: current_user }
    }, status: :ok
  end

  def respond_to_on_destroy
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last,
                             Rails.application.credentials.fetch(:secret_key_base)).first
    current_user = User.find(jwt_payload['sub'])
    if current_user
      render json: {
               status: { code: 200, message: 'User logged out successfully.' }
             },
             status: :ok
    else
      render json: {
               status: { code: 401, message: 'User has no active session' }
             },
             status: :unauthorized

    end
  end
end
