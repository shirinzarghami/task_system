class TaskOccurrencesController < ApplicationController
  add_crumb(lambda {|instance| instance.t('breadcrumbs.communities')}) { |instance| instance.send :communities_path }
  before_filter :find_community
  before_filter :find_task, only: [:create, :new]
  before_filter :find_task_occurrence, only: [:update, :destroy, :reassign, :complete, :show]
  before_filter :check_community_admin, only: [:destroy]
  before_filter :set_tasks_breadcrumbs, only: [:show, :todo, :open, :completed, :new]

  def show
    @comment = Comment.new
    @comments = @task_occurrence.root_comments.paginate(page: params[:page], per_page: 10)
  end



  def new
    add_crumb t('breadcrumbs.new'), new_community_task_occurrence_path(@community)

    @task_occurrence = TaskOccurrence.new
    if @task.present?
      @task_occurrence.user = @task.allocated_user if @task.allocation_mode == 'user'
      show_modal :form_modal
    else
      render 'new'
    end
  end

  def create
    if @task
      @task.schedule(task_occurrence_create_params) ? redirect_success : redirect_error
    else 
      @task_occurrence = @community.task_occurrences.create single_task_occurrence_params
      if @task_occurrence.save
        redirect_success
      else 
        flash[:error] = t('messages.save_fail')
        render 'new'
      end
    end
  end

  def update
    @task_occurrence.update_attributes(task_occurrence_params) ? redirect_success : redirect_error
  end

  # Both reassign and complete route to update via PUT
  def reassign
    show_modal :reassign
  end

  def complete
    show_modal :complete
  end

  def destroy
    @task_occurrence.destroy ? redirect_success : redirect_error
  end

  private
    def find_task
      @task = @community.tasks.find_by_id params[:task_id]
    end

    def find_task_occurrence
      @task_occurrence = TaskOccurrence.find params[:id]
      @task = @task_occurrence.task
    end

    def task_occurrence_params
      if community_admin?
        {"user_id" => @user.id}.merge params.require(:task_occurrence).permit(:checked, :remarks, :user_id)
      elsif @task_occurrence.user == @user or @task_occurrence.user.nil?
        {"user_id" => @user.id}.merge params.require(:task_occurrence).permit(:checked, :remarks)
      end
    end

    def single_task_occurrence_params
      params.require(:task_occurrence).permit(:task_name, :deadline, :time_in_minutes, :should_be_checked, :user_id)
    end

    def task_occurrence_create_params
      # The allocation user may only be set when the allocation mode is set to user, or the current user is admin
      if params.has_key?(:task_occurrence) and (@task.allocation_mode == 'user' or community_admin?)
        params[:task_occurrence].permit(:user_id) 
      end
    end

    def set_tasks_breadcrumbs
      # add_crumb t('breadcrumbs.schedule'), community_tasks_path(@community)
    end

    def redirect_error
      flash[:error] = t('messages.save_fail')
      redirect_to todo_community_task_occurrences_path @community
    end

    def redirect_success
      flash[:notice] = t('messages.save_success')
      redirect_to todo_community_task_occurrences_path @community
    end
end
