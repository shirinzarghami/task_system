module ButtonHelper

  def submit_button text=t('actions.submit'), type=[:right]
    button(text, [:right, :submit_button], 'submit_button')
  end


  def button text=t('actions.submit'), type=nil, id=nil
    # "<div class='button #{type.map {|s| s.to_s}.compact.join(" ") unless type.nil?}' id=#{id unless id.nil?}><a href='#'>#{text}</a></div>".html_safe
    content_tag :div, class: ('button ' + type.map {|s| s.to_s}.compact.join(" ") unless type.nil?), id: (id unless id.nil?) do
      link_to text, '#'
    end
  end

  def tab_link text, url
    # "<li class='#{current_page?(url) ? 'active' : ''}'>#{link_to text, url}</li>".html_safe
    content_tag :li, class: (controller.controller_name == text.downcase ? 'active' : '') do
      link_to text, url
    end
  end

  def filter_button text, filter_name
    content_tag :li, id: filter_name, class: 'filter' do
      link_to text, params.merge(filter: filter_name), class: "button", remote: true
    end
  end

  def image_button image, link, link_options={}, image_options={}
    link_to image_tag(image, image_options), link, link_options
  end

  # Bootstrap buttons

  def icon_button text, url, options = {link_class: '', icon_class: '', icon_white: false}
    render partial: 'shared/bootstrap_button', locals: {options: options, text: text, url: url}
  end
end