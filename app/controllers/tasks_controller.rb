class TasksController < ApplicationController
  before_filter :find_community
  before_filter :find_task, only: [:edit, :update, :destroy]
  before_filter :check_destroy_allowed, only: [:destroy]

  def index
    @tasks = @community.tasks.paginate(page: params[:page], per_page: 20)
  end

  def show
  end

  def new
    @task = @community.tasks.build
    @members = @community.members
  end

  def create
    @task = @community.tasks.build task_params
    if @task.save
      flash[:notice] = t('messages.save_success')
      redirect_to community_tasks_path @community
    else
      flash[:error] = t('messages.save_fail')
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @task.update_attributes task_params
      flash[:notice] = t('messages.save_success')
      redirect_to community_tasks_path @community
    else
      flash[:error] = t('messages.save_fail')
      render action: 'edit'
    end
  end

  def destroy
    if @task.destroy
      flash[:notice] = t('messages.task_destroy_success')
      redirect_to community_tasks_path @community
    else
      flash[:error] = t('messages.task_destroy_fails')
      render action: 'edit'
    end
  end

  private
    def find_task
      @task = @community.tasks.find(params.has_key?(:task_id) ? params[:task_id] : params[:id]) 
    end

    def check_destroy_allowed
      check @task.user == @user or community_admin?
    end

    def task_params
      if community_admin? or @task.nil? or @task.user == @user
        params.require(:task).permit(:allocated_user_id, :allocation_mode, :deadline, :description, :interval, :next_occurrence, :name, :repeat, :should_be_checked, :time, :user_id, :user_order, :instantiate_automatically, :interval_unit, :repeat_infinite, :deadline_unit).merge(user: @user)
      end
    end
end
