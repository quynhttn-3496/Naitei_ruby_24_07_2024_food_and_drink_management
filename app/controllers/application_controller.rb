class ApplicationController < ActionController::Base
  before_action :set_locale
  include SessionsHelper
  include Pagy::Backend

  def set_order
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:warning] = t "orders.not_found"
    redirect_to root_path
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def authenticate_admin!
    return if current_user.admin?

    redirect_to root_path, alert: t("not_admin")
  end
end
