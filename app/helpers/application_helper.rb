module ApplicationHelper
  include Pagy::Frontend

  def full_title page_title
    base_title = t "helper.title_name"
    page_title.blank? ? base_title : "#{page_title}|#{base_title}"
  end

  def convert_currency amount
    number_to_currency(
      I18n.locale == :en ? amount.exchange_to(:USD) : amount.exchange_to(:VND),
      unit: I18n.locale == :en ? "$" : "₫",
      format: I18n.locale == :en ? "%u%n" : "%n%u"
    )
  end

  def calculate_discounted_price original_price, discount_percentage
    discounted_amount = original_price * (discount_percentage / 100.0)
    original_price - discounted_amount
  end

  def currency_options
    [%w(VND VND), %w(USD USD)]
  end
end
