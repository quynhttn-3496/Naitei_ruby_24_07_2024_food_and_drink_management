class Api::V1::SessionsController < Api::V1::ApplicationController
  def create
    @user = User.find_by email: params.dig(:session, :email)&.downcase

    if @user&.valid_password? params.dig(:session, :password)
      @token = encode_token(user_id: @user.id)
      render json: {
        user: UserSerializer.new(@user),
        token: @token,
        message: I18n.t("messages.session.login_success")
      }, status: :accepted
    else
      render json: {message:
                    I18n.t("messages.session.invalid_email_or_password")},
             status: :unprocessable_entity
    end
  end
end
