class User::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin, only: :index

  def index
    @orders = Order.with_status(params[:status]).for_user(current_user)
    render :index
  end

  private
  def authenticate_user!
    return if logged_in?

    redirect_to root_path, alert: t("not_signed")
  end

  def check_admin
    return unless current_user.admin?

    redirect_to admin_orders_path
  end
end
