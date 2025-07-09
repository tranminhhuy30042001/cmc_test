class AuthController < ApplicationController
  skip_before_action :authorize_request, only: [:signup, :login]

  def signup
    result = AuthService.signup(user_params)

    if result[:success]
      render json: result[:data], status: :created
    else
      render_error(result[:error], :unprocessable_entity)
    end
  end

  def login
    result = AuthService.login(user_params)

    if result[:success]
      render json: result[:data], status: :ok
    else
      render_error(result[:error], :unauthorized)
    end
  end

  def refresh
    result = AuthService.refresh(params[:refresh_token])

    if result[:success]
      render json: result[:data], status: :ok
    else
      render_error(result[:error], :unauthorized)
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
