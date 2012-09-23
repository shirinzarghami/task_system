class TasksController < ApplicationController
  before_filter :check_community, only: [:index, :show, :new, :create, :edit]
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
  end

  def destroy
  end
end
