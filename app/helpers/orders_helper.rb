module OrdersHelper
  def payment_method_options
    options_for_select([
                         [t("order.payment_method_choose"), nil],
      [t("order.credit_card"), "credit_card"],
      [t("order.paypal"), "paypal"],
      [t("order.bank_transfer"), "bank_transfer"]
                       ])
  end
end
