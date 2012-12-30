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

  def tab_link text, url, options = {}, &block
    default_options = {
      icon_class: '',
      controller_list: [],
      dropdown: false
    }
    options = default_options.merge options
    icon_html = options[:icon_class].present? ? content_tag(:i, '', class: options[:icon_class]) : ''
    is_active = (options[:controller_list].select {|c| controller.controller_name == c.to_s}.any? or controller.controller_name == text.downcase)

    li_class = is_active ? 'active' : ''
    li_class+= ' dropdown' if options[:dropdown]

    link_options = options[:dropdown] ? {:class => 'dropdown-toggle', 'data-toggle' => 'dropdown'} : {}

    subcontent = block_given? ? capture(&block) : nil
    link = link_to "#{icon_html} #{text}".html_safe, url, link_options

    content = link + subcontent
    content_tag :li,content, class: li_class
    
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