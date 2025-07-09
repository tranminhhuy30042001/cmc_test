class AuthService
  INVALID_CREDENTIALS = 'Invalid credentials'.freeze
  INVALID_REFRESH_TOKEN = 'Invalid refresh token'.freeze

  def self.signup(params)
    user = User.new(params)

    if user.save
      tokens = generate_tokens_for(user)
      {
        success: true,
        data: build_response(user, tokens)
      }
    else
      {
        success: false,
        error: user.errors.full_messages
      }
    end
  end

  def self.login(params)
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      tokens = generate_tokens_for(user)
      {
        success: true,
        data: build_response(user, tokens)
      }
    else
      {
        success: false,
        error: INVALID_CREDENTIALS
      }
    end
  end

  def self.refresh(refresh_token)
    user = User.find_by(refresh_token: refresh_token)

    if user
      new_token = JsonWebToken.encode(user_id: user.id)
      {
        success: true,
        data: { token: new_token }
      }
    else
      {
        success: false,
        error: INVALID_REFRESH_TOKEN
      }
    end
  end

  private

  def self.generate_tokens_for(user)
    {
      token: JsonWebToken.encode(user_id: user.id),
      refresh_token: SecureRandom.hex(32).tap { |token| user.update(refresh_token: token) }
    }
  end

  def self.build_response(user, tokens)
    {
      token: tokens[:token],
      refresh_token: tokens[:refresh_token],
      user: user.as_json(only: [:id, :email, :role])
    }
  end
end
