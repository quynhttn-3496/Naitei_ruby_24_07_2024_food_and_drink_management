module ReviewsHelper
  def render_stars_with_rating rating
    max_stars = 5

    stars_html = (1..max_stars).map do |i|
      star_class = i <= rating ? "text-yellow-400" : "text-gray-400"
      svg_attributes = {
        class: "w-6 h-6 #{star_class} inline-block",
        data: {rating: i},
        xmlns: "http://www.w3.org/2000/svg",
        viewBox: "0 0 24 24",
        fill: "currentColor"
      }
      path_attributes = {
        fill_rule: "evenodd",
        d: "M10.788 3.21c.448-1.077 1.976-1.077 2.424 0l2.082 5.006 5.404.434c1.164.093 1.636 1.545.749 2.305l-4.117 3.527 1.257 5.273c.271 1.136-.964 2.033-1.96 1.425L12 18.354 7.373 21.18c-.996.608-2.231-.29-1.96-1.425l1.257-5.273-4.117-3.527c-.887-.76-.415-2.212.749-2.305l5.404-.434 2.082-5.005Z", # rubocop:disable Layout/LineLength
        clip_rule: "evenodd"
      }

      content_tag(:svg, svg_attributes) do
        content_tag(:path, "", path_attributes)
      end
    end

    safe_join(stars_html, "")
  end

  def rating_bar rating, max_stars
    percentage = (rating.to_f / max_stars) * 100

    content_tag(:p,
                class: "h-2 w-full xl:min-w-[278px] rounded-[30px] bg-gray-200
                  ml-5 mr-3") do
      content_tag(:span, "", class: "h-full rounded-[30px] bg-indigo-500 flex",
      style: "width: #{percentage}%;")
    end
  end
end
