module TasksHelper

  def can_edit_task? task=@task
    task.user == @user or @community_user.role == 'admin'
  end

  def next_allocated_user task
    user = task.next_allocated_user
    user ? user.name : t('activerecord.attributes.task.allocation_modes_short.voluntary')
  end

  def task_occurrence_status task_occurrence
    if task_occurrence.completed?
      completed_date = task_occurrence.should_be_checked? ? task_occurrence.completed_at : task_occurrence.deadline
      t('activerecord.attributes.task_occurrence.statuses.completed_at')
    else
      t('activerecord.attributes.task_occurrence.statuses.uncompleted')
    end
  end
end
