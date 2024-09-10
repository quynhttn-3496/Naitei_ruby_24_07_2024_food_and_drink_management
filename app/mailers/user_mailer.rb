class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: "acount activation"
  end

  def password_reset
    @user = user
    mail to: user.email, subject: "reset pass"
  end
end
