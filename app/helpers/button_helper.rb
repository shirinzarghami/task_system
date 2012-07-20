module ButtonHelper

  def submit_button text=t('actions.submit'), type=[:right]
    button(text, [:right, :submit_button], 'submit_button')
  end


  def button text=t('actions.submit'), type=nil, id=nil
    "<div class='button #{type.map {|s| s.to_s}.compact.join(" ") unless type.nil?}' id=#{id unless id.nil?}><a href='#'>#{text}</a></div>".html_safe
  end

  def tab_link text, url
    "<li class='#{current_page?(url) ? 'active' : ''}'>#{link_to text, url}</li>".html_safe
  end

  def filter_button text, filter_name
    link_to text, params.merge(filter: filter_name), class: "button filter", id: filter_name, remote: true
  end


end