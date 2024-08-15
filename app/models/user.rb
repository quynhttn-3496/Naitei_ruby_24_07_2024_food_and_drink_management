class User < ApplicationRecord
  enum role: {admin: 0, user: 1}

  has_one :cart, dependent: :destroy
  has_one :address, dependent: :destroy
  has_many :reviews, dependent: :destroy, as: :reviewable
  has_many :orders, dependent: :destroy

  accepts_nested_attributes_for :address
  before_save :downcase_email
  attr_accessor :remember_token

  PERMITTED_ATRIBUTES = %i(username email password password_confirmation).freeze
  validates :username, presence: true,
    length: {maximum: Settings.validate_len_name}
  validates :email, presence: true,
    length: {maximum: Settings.validate_len_email},
    format: {with: Settings.VALID_EMAIL_REGEX}, uniqueness: true
  has_secure_password

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost:
  end

  private
  def downcase_email
    email.downcase!
  end
end
