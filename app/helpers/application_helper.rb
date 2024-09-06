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

  def soical_share_link platform
    base_url = "https://www.#{platform}.com/sharer/sharer.php?u="

    onclick_code = <<-JS.strip_heredoc
      var width = 600;
      var height = 500;
      var left = (window.innerWidth - width) / 2;
      var top = (window.innerHeight - height) / 2;
      window.open(this.href, "", "menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=" + height + ",width=" + width + ",top=" + top + ",left=" + left);
      return false;
    JS

    link_to "#{base_url}#{request.original_url}",
            onclick: onclick_code,
            class: "social-share-link" do
              image_tag "#{platform}.png", alt: platform
            end
  end
end
