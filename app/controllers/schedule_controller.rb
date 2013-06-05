class ScheduleController < ApplicationController
  add_crumb(lambda {|instance| instance.t('breadcrumbs.communities')}) { |instance| instance.send :communities_path }
  before_filter :find_community
  before_filter :set_breadcrumbs
  def todo
    add_crumb t('breadcrumbs.todos'), community_schedule_todo_path(@community)
    @task_occurrences = @community.task_occurrences.for_user_or_open(@user).todo.paginate(page: params[:page],per_page: 20)
  end

  def open
    add_crumb t('breadcrumbs.open'), community_schedule_todo_path(@community)
    @task_occurrences = @community.task_occurrences.todo.paginate(page: params[:page],per_page: 20)
  end

  def completed
    add_crumb t('breadcrumbs.completed'), community_schedule_todo_path(@community)
    @task_occurrences = @community.task_occurrences.completed.paginate(page: params[:page], per_page: 20)
  end

  private
    def set_breadcrumbs
      set_community_breadcrumb
      add_crumb t('breadcrumbs.schedule'), community_tasks_path(@community)
    end
end
