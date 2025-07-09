class User < ApplicationRecord
  has_secure_password

  has_many :assets, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }

  validates :role,
            presence: true,
            inclusion: { in: %w[admin customer], message: "%{value} is not a valid role" }

  validates :password,
            presence: true,
            length: { minimum: 6 },
            if: :password_required?

  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end

  def password_required?
    new_record? || !password.nil?
  end
end
