class SessionsController < ApplicationController
  def new; end

  def create
    user = find_user_by_email
    if authenticate_user user
      log_in_and_redirect user
    else
      handle_invalid_login
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def find_user_by_email
    User.find_by email: params.dig(:session, :email)&.downcase
  end

  def authenticate_user user
    user.try :authenticate, params.dig(:session, :password)
  end

  def log_in_and_redirect user
    log_in user
    flash[:success] = t "view.users.success"
    redirect_to root_path, status: :see_other
  end

  def handle_invalid_login
    flash.now[:danger] = t "view.sessions.invalid_email_password_combination"
    render :new, status: :unprocessable_entity
  end
end
