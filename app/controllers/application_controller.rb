class ApplicationController < ActionController::API
  include JsonWebToken

  before_action :authorize_request
  attr_reader :current_user

  private

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    decoded = JsonWebToken.decode(token)
    @current_user = User.find_by(id: decoded[:user_id]) if decoded

    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end
end
