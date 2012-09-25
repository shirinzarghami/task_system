module TasksHelper

  def can_edit_task? task=@task
    task.user = @user or @community_user.role == 'admin'
  end
end
