class AuthController < ApplicationController
  skip_before_action :authorize_request, only: [:signup, :login]

  INVALID_CREDENTIALS = 'Invalid credentials'.freeze
  INVALID_REFRESH_TOKEN = 'Invalid refresh token'.freeze

  def signup
    user = User.new(user_params)
  
    if user.save
      access_token = JsonWebToken.encode(user_id: user.id)
      refresh_token = SecureRandom.hex(32)
      user.update(refresh_token: refresh_token)
  
      render json: {
        token: access_token,
        refresh_token: refresh_token,
        user: user.as_json(only: [:id, :email, :role])
      }, status: :created
    else
      render_error(user.errors.full_messages, :unprocessable_entity)
    end
  end

  def login
    user = User.find_by(email: user_params[:email])
  
    if user&.authenticate(user_params[:password])
      access_token = JsonWebToken.encode(user_id: user.id)
      refresh_token = SecureRandom.hex(32)
      user.update(refresh_token: refresh_token)
  
      render json: {
        token: access_token,
        refresh_token: refresh_token,
        user: user.as_json(only: [:id, :email, :role])
      }, status: :ok
    else
      render_error(INVALID_CREDENTIALS, :unauthorized)
    end
  end

  def refresh
    user = User.find_by(refresh_token: params[:refresh_token])
  
    if user
      new_token = JsonWebToken.encode(user_id: user.id)
      render json: { token: new_token }, status: :ok
    else
      render_error(INVALID_REFRESH_TOKEN, :unauthorized)
    end
  end

  private

  def user_params
    params.permit(:email, :password, :role)
  end

  def render_error(message, status)
    render json: { error: message }, status: status
  end
end
