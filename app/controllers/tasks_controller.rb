class TasksController < ApplicationController
  before_filter :check_community, only: [:index, :show, :new, :create, :edit]
  before_filter :find_task, only: [:edit, :update, :destroy]
  before_filter :check_task, only: [:edit, :update, :destroy]

  def index
    @tasks = @community.tasks
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
  end

  protected
    def find_task
      @task = @community.tasks.find(params.has_key?(:task_id) ? params[:task_id] : params[:id]) 
    end
    def check_task
      check((@community_user.role == 'admin' or @task.user == @user), community_tasks_path(@community))
    end
end
