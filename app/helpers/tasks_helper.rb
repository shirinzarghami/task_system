module TasksHelper

  def can_edit_task? task=@task
    task.user == @user or @community_user.role == 'admin'
  end

  def next_allocated_user task
    user = task.next_allocated_user
    user ? user.name : t('activerecord.attributes.task.allocation_modes_short.voluntary')
  end
end
