module TaskOccurrencesHelper

  def action_tab text, action_name
    li_class = controller.action_name == action_name.to_s ? 'active' : ''
    content_tag :li, class: li_class do
      link_to text, controller: :task_occurrences, action: action_name
    end
  end

  def number_of_comments task_occurrence
    count = task_occurrence.comment_threads.count
    count unless count == 0
  end
end
