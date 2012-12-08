class TasksController < ApplicationController
  before_filter :find_community
  # before_filter :check_community, only: [:index, :show, :new, :create, :edit]
  before_filter :find_task, only: [:edit, :update, :destroy]

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
    @task = @community.tasks.build params[:task]
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
    if @task.update_attributes params[:task]
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

  protected
    def find_task
      @task = @community.tasks.find(params.has_key?(:task_id) ? params[:task_id] : params[:id]) 
    end
end
