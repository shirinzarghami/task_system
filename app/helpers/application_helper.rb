module ApplicationHelper


  def submit_button text="Submit", type=[:right]
    button(text, [:right, :submit_button], 'submit_button')
  end

  def button text="Submit", type=nil, id=nil
    "<div class='button #{type.map {|s| s.to_s}.compact.join(" ") unless type.nil?}' id=#{id unless id.nil?}><a href='#'>#{text}</a></div>".html_safe
  end

  def tab_link text, url
    "<li class='#{current_page?(url) ? 'active' : ''}'>#{link_to text, url}</li>".html_safe
  end
end
