module ApplicationHelper
  include Pagy::Frontend
  def full_title page_title
    base_title = t "helper.title_name"
    page_title.blank? ? base_title : "#{page_title}|#{base_title}"
  end
end
