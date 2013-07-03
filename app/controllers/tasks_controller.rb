class TasksController < ApplicationController
  add_crumb(lambda {|instance| instance.t('breadcrumbs.communities')}) { |instance| instance.send :communities_path }
  before_filter :find_community
  before_filter :set_breadcrumbs, only: [:index, :show, :new, :edit]
  before_filter :find_task, only: [:edit, :update, :destroy, :show]
  before_filter :check_destroy_allowed, only: [:destroy]
  before_filter :check_edit_allowed, only: [:edit, :update]

  include Sortable::Controller
  sort :task, default_column: :name, default_direction: :asc
  
  rescue_from ActiveRecord::RecordNotFound do
    flash[:error] = t('messages.task_not_found')
    redirect_to (@community.present? ? community_tasks_path(@community) : communities_path)
  end
  def index
    @tasks = @community.tasks.where(search_conditions).order(sort_column + ' ' + sort_direction).paginate(page: params[:page], per_page: 20)
  end

  def show
    @task_occurrences = @task.task_occurrences.latest.paginate(page: params[:page], per_page: 20)
  end

  def new
    @task = @community.tasks.build
    @members = @community.members
    add_crumb(t('breadcrumbs.new'), new_community_task_path(@community))
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
      redirect_to community_tasks_path @community
    end
  end

  private
    def find_task
      @object ||= @task ||= @community.tasks.find(params.has_key?(:task_id) ? params[:task_id] : params[:id]) 
      # add_crumb(t('breadcrumbs.tasks'), community_tasks_path(@community))
      add_crumb(@task.name, community_task_path(@community, @task))
    end

    def task_params
      params.require(:task).permit(:allocated_user_id, :allocation_mode, :deadline, :description, :interval, :next_occurrence, :name, :repeat, :should_be_checked, :time, :user_id, :ordered_user_ids, :ignored_user_ids, :instantiate_automatically, :interval_unit, :repeat_infinite, :deadline_unit).merge(user: @user)
    end

    def check_edit_allowed
      edit_allowed = (community_admin? or @task.nil? or @task.user == @user)
      check edit_allowed, url: community_tasks_path(@community), flash: t('tasks.flash.save_not_allowed')
    end

    def set_breadcrumbs
      set_community_breadcrumb
      add_crumb t('breadcrumbs.tasks'), community_tasks_path(@community)
    end

    def search_conditions
      if params.has_key?(:q) && params[:q].present?
        search = "%#{params[:q]}%"
        ['name LIKE ? OR description LIKE ?', search, search]
      end
    end
end
