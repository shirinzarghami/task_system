class TaskOccurrencesController < ApplicationController
  before_filter :find_task, except: [:index]
  def index
    @my_todos = TaskOccurrence.for_user(@user).for_community(@community)
  end

  def create
    @task_occurrence = @task.task_occurrences.build
    @task_occurrence.deadline = Time.now + @task.deadline
    @task_occurrence.allocate

    if @task_occurrence.save
      flash[:notice] = t('messages.save_success')
      redirect_to community_tasks_path @community
    else
      flash[:error] = t('messages.save_fail')
      redirect_to community_tasks_path @community
    end
  end
    

  def new
    respond_to do |format|
      format.js
    end
  end

  private
    def find_task
      @task = @community.tasks.find(params[:task_id])
    end
end
