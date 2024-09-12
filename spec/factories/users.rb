FactoryBot.define do
  factory :user do
    username { "Sample User" }
    sequence(:email) { |n| "user#{n}@gmail.com" }
    password { "password" }
    confirmed_at {Time.now}
    role { 0 }
    phone { "1234567890" }
    address { "123 Main St" }
    password_confirmation { "password" }
    encrypted_password { Devise::Encryptor.digest(User, password) }
    reset_password_token { SecureRandom.urlsafe_base64 }
    reset_password_sent_at { Time.current }
    remember_created_at { Time.current }
    sign_in_count { 0 }
    current_sign_in_at { Time.current }
    last_sign_in_at { Time.current }
    current_sign_in_ip { "127.0.0.1" }
    last_sign_in_ip { "127.0.0.1" }
    confirmation_token { SecureRandom.urlsafe_base64 }
    confirmation_sent_at { Time.current }
    unconfirmed_email { nil }
    failed_attempts { 0 }
    unlock_token { SecureRandom.urlsafe_base64 }
    locked_at { nil }
    provider { "email" }
    uid { SecureRandom.uuid }
    activation_digest { SecureRandom.urlsafe_base64 }
    activated { true }
    activated_at { Time.current }
  end
end
