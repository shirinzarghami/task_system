module TaskOccurrencesHelper

  def action_tab text, action_name, options = {}
    li_class = controller.action_name == action_name.to_s ? 'active' : ''

    icon_html = options[:icon_file].present? ? content_tag(:i, image_tag(options[:icon_file])) : ''

    link_html = link_to icon_html + text, controller: :schedule, action: action_name
    content_tag :li, (link_html),class: li_class
      
  end

  def number_of_comments task_occurrence
    count = task_occurrence.comment_threads.count
    count unless count == 0
  end
end
