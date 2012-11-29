class TaskOccurrencesController < ApplicationController
  before_filter :find_task, only: [:create, :new]
  before_filter :find_and_check_task_occurrence, only: [:update, :destroy]
  before_filter :check_admin, only: [:destroy]

  def index
    @my_todos = TaskOccurrence.for_user(@user).for_community(@community).todo
    @all_open = TaskOccurrence.for_community(@community).todo
    @history = TaskOccurrence.for_community(@community).completed
  end

  def new
    @task_occurrence = TaskOccurrence.new
    @task_occurrence.user = @task.allocated_user if @task.allocation_mode == 'user'
    respond_to do |format|
      format.js
    end
  end

  def create
    @task_occurrence = @task.task_occurrences.build task_occurrence_create_params
    @task_occurrence.deadline = Time.now + @task.deadline_time
    @task_occurrence.allocate unless @task_occurrence.user.present?

    if @task_occurrence.save
      flash[:notice] = t('messages.save_success')
      redirect_to community_task_occurrences_path @community
    else
      flash[:error] = t('messages.save_fail')
      redirect_to community_task_occurrences_path @community
    end
  end

  def update
    if @task_occurrence.update_attributes(task_occurrence_params)
      flash[:notice] = t('messages.save_success')
      redirect_to community_task_occurrences_path @community
    else
      flash[:error] = t('messages.save_fail')
      redirect_to community_task_occurrences_path @community
    end
  end

  def destroy
    if @task_occurrence.destroy
      flash[:notice] = t('messages.save_success')
      redirect_to community_task_occurrences_path @community
    else
      flash[:error] = t('messages.save_fail')
      redirect_to community_task_occurrences_path @community
    end
  end

  private
    def find_task
      @task = @community.tasks.find(params[:task_id])
    end

    def find_and_check_task_occurrence
      @task_occurrence = TaskOccurrence.find params[:id]
      check @task_occurrence, community_tasks_path(@community)
      @task = @task_occurrence.task
    end

    def task_occurrence_params
      if community_admin?
        params.require(:task_occurrence).permit(:checked, :remarks, :user)
      elsif @task_occurrence.user == @user
        params.require(:task_occurrence).permit(:checked, :remarks)
      end
    end

    def task_occurrence_create_params
      # The allocation user may only be set when the allocation mode is set to user, or the current user is admin
      if params.has_key?(:task_occurrence) and (@task.allocation_mode == 'user' or community_admin?)
        params[:task_occurrence].permit(:user_id) 
      end
    end
end
