class UsersController < ApplicationController
  def create
    ActiveRecord::Base.transaction do
      @user = User.new(user_params)
      if @user.save
        # Tạo giỏ hàng cho người dùng mới
        @user.create_cart!

        flash[:success] = "Người dùng và giỏ hàng đã được tạo thành công."
        redirect_to users_path
      else
        flash.now[:error] = "Có lỗi xảy ra khi tạo người dùng."
        render :index
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:error] = "Có lỗi xảy ra: #{e.message}"
    render :index
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :password, :role, :phone, :address)
  end
end
