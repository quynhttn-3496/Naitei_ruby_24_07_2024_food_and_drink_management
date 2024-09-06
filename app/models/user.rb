class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable,
         :trackable, :omniauthable, omniauth_providers: [:google_oauth2]
  PERMITTED_ATRIBUTES = %i(username email password password_confirmation).freeze
  enum role: {admin: 0, user: 1}

  has_one :cart, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :orders, dependent: :destroy

  accepts_nested_attributes_for :addresses
  attr_accessor :activation_token

  before_save :downcase_email

  after_create :create_cart, :create_activation_digest

  validates :username, presence: true,
    length: {maximum: Settings.validate_len_name}
  validates :email, presence: true,
    length: {maximum: Settings.validate_len_email},
    format: {with: Settings.VALID_EMAIL_REGEX}, uniqueness: true

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost:
  end

  def self.from_omniauth access_token
    data = access_token.info
    user = User.where(email: data["email"]).first

    user ||= User.create(username: data["name"],
                         email: data["email"],
                         password: Devise.friendly_token[0, 20],
                         provider: access_token[:provider],
                         uid: access_token[:uid])
    user
  end

  def create_cart
    Cart.create!(user: self)
  end

  private
  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    # self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end
end
