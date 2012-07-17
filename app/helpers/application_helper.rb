module ApplicationHelper

  def submit_button text="Submit"
    button(text, [:right])
  end

  def button text="Submit", type=nil
    "<div class='button #{type.map {|s| s.to_s}.compact.join(" ") unless type.nil?}'><a href='#'>#{text}</a></div>".html_safe
  end

  def tab_link text, url
    "<li class='#{current_page?(url) ? 'active' : ''}'>#{link_to text, url}</li>".html_safe
  end
end
