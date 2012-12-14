class TaskOccurrencesController < ApplicationController
  before_filter :find_community
  before_filter :find_task, only: [:create, :new]
  before_filter :find_task_occurrence, only: [:update, :destroy, :reassign, :complete]
  before_filter :check_community_admin, only: [:destroy]

  def index
    @my_todos = TaskOccurrence.for_user_or_open(@user).for_community(@community).todo.paginate(page: params[:todo_page], per_page: 20)
    @all_open = TaskOccurrence.for_community(@community).todo.paginate(page: params[:open_page], per_page: 20)
    @history = TaskOccurrence.for_community(@community).completed.paginate(page: params[:history_page], per_page: 20)
  end

  def new
    @task_occurrence = TaskOccurrence.new
    @task_occurrence.user = @task.allocated_user if @task.allocation_mode == 'user'
    show_modal :form
  end

  def create
    if @task.schedule task_occurrence_create_params
      flash[:notice] = t('messages.save_success')
      redirect_to community_task_occurrences_path @community
    else
      flash[:error] = t('messages.save_fail')
      redirect_to community_task_occurrences_path @community
    end
  end

  def update
    if @task_occurrence.update_attributes task_occurrence_params
      flash[:notice] = t('messages.save_success')
      redirect_to community_task_occurrences_path @community
    else
      flash[:error] = t('messages.save_fail')
      redirect_to community_task_occurrences_path @community
    end
  end

  # Both reassign and complete route to update via PUT
  def reassign
    show_modal :reassign
  end

  def complete
    show_modal :complete
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

    def find_task_occurrence
      @task_occurrence = TaskOccurrence.find params[:id]
      @task = @task_occurrence.task
    end

    def task_occurrence_params
      if community_admin?
        {"user_id" => @user}.merge params.require(:task_occurrence).permit(:checked, :remarks, :user_id)
      elsif @task_occurrence.user == @user or @task_occurrence.user.nil?
        {"user_id" => @user}.merge params.require(:task_occurrence).permit(:checked, :remarks)
      end
    end

    def task_occurrence_create_params
      # The allocation user may only be set when the allocation mode is set to user, or the current user is admin
      if params.has_key?(:task_occurrence) and (@task.allocation_mode == 'user' or community_admin?)
        params[:task_occurrence].permit(:user_id) 
      end
    end
end
