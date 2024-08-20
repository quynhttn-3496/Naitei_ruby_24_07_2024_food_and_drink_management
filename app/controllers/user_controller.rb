class UsersController < ApplicationController
  USER_PARAMS = %i(email username password role phone address).freeze

  def create
    ActiveRecord::Base.transaction do
      @user = User.new(user_params)
      @user.save!
      @user.create_cart!
      handle_save_success
    end
  rescue ActiveRecord::RecordInvalid => e
    handle_record_invalid e
  end

  private

  def user_params
    params.require(:user).permit(*USER_PARAMS)
  end

  def handle_save_failure
    flash.now[:error] = t "users.create_failed"
    render :index
  end

  def handle_save_success
    flash[:success] = t "users.created_success"
    redirect_to users_path
  end

  def handle_record_invalid exception
    flash.now[:error] = "#{t('errors')} #{exception.message}"
    render :index
  end
end
