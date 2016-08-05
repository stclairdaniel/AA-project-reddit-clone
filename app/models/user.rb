class User < ActiveRecord::Base
  validates :user_name, :session_token, :password_digest, presence: true
  validates :user_name, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }

  attr_reader :password
  after_initialize :ensure_session_token

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    check_password = BCrypt::Password.new(self.password_digest)
    check_password.is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    @user = User.find_by(user_name: user_name)
    return nil unless @user
    return nil unless @user.is_password?(password)
    @user
  end

  def generate_session_token
    SecureRandom.urlsafe_base64(32)
  end

  def reset_session_token!
    new_token = generate_session_token
    self.session_token = new_token
    self.save!
    new_token
  end

  private
  def ensure_session_token
    self.session_token ||= generate_session_token
  end
end
