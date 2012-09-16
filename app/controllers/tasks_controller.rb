class TasksController < ApplicationController
  def index
    @tasks = @community.tasks
  end

  def show
  end

  def new
    @task = @community.tasks.build
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
