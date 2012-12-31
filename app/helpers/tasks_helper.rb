module TasksHelper

  def can_edit_task? task=@task
    task.user == @user or @community_user.role == 'admin'
  end

  def next_allocated_user task
    user = task.next_allocated_user
    user ? user.name : t('activerecord.attributes.task.allocation_modes_short.voluntary')
  end

  def task_occurrence_status task_occurrence

    status_text = if task_occurrence.completed?
                    completed_date = task_occurrence.should_be_checked? ? task_occurrence.completed_at : task_occurrence.deadline
                    t('activerecord.attributes.task_occurrence.statuses.completed_at', date: l(completed_date, format: :date_only))
                  else
                    t('activerecord.attributes.task_occurrence.statuses.uncompleted')
                  end

    status_class = if task_occurrence.too_late?
                    'error-text'
                   else
                    task_occurrence.completed? ? 'valid-text' : 'danger-text'
                   end
    content_tag :span, status_text, class: status_class
  end

  def task_distribution task
    # result = TaskOccurrence.joins("RIGHT OUTER JOIN community_users ON task_occurrences.user_id = community_users.user_id").where(["(task_occurrences.task_id = ? OR task_occurrences.task_id IS NULL)", task.id]).group("community_users.user_id").count
    # result.to_a.map {|i| {label: User.find(i.first).name, value: i.last}}.to_json
    result = TaskOccurrence.joins("RIGHT OUTER JOIN users ON task_occurrences.user_id = users.id").where(["task_occurrences.task_id = ?", task.id]).group("users.id").select('users.name as label, COUNT(users.id) as value')
    result.to_json

  end
end
