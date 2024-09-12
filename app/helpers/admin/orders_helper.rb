module Admin::OrdersHelper
  def status_options_for_select
    Order.statuses.keys.map do |status|
      [status.humanize, Order.statuses[status]]
    end
  end
end
