require Rails.root.join('lib','sortable.rb')
class ApplicationController < ActionController::Base
  include Sortable::Controller

  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :find_user
  
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500, exception }
    # rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  end
  unless Rails.env.development?
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  end

  def find_user
    @user = current_user
  end

  def find_community
    @community ||= @user.communities.find_by_subdomain! params.has_key?(:community_id) ? params[:community_id] : params[:id] if @user
    @community_user ||= CommunityUser.find_by_community_id_and_user_id!(@community, @user)
  end

  def set_community_breadcrumb
    add_crumb(@community.name, community_path(@community))
  end

  def current_ability
    find_community
    @current_ability ||= Ability.new(@community_user)
  end

  # Redirect if confition does not hold
  def check condition, options ={}
    options = {url: communities_path, flash: t('messages.not_allowed')}.merge options

    unless condition
      flash[:error] = options[:flash]
      redirect_to options[:url]
    end
  end

  def check_community_admin
    check community_admin?    
  end

  def community_admin? community=nil
    if community.nil?
      @community_user and @community_user.admin?
    else
      CommunityUser.find_by_community_id_and_user_id!(community, @user).try(:admin?)
    end
  end

  def show_modal partial
    respond_to do |format|
      @partial = partial.to_s
      format.js {render 'shared/modal'}
    end
  end

  def error_messages_for object, flash = ""
    render_to_string('shared/errors', layout: false, formats: [:html], locals: {object: object, flash: flash}).html_safe
  end

  def after_sign_in_path_for(user)
    if user.communities.count == 1
      community_path user.communities.first
    else
      communities_path 
    end
  end

  def check_destroy_allowed
    condition = (@object.user == @user or community_admin?)
    check condition
  end

  def load_commentable
    klass = [TaskOccurrence, Payment].detect {|c| params["#{c.name.underscore}_id"]}
    @commentable = klass.find params["#{klass.name.underscore}_id"]
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction
  end

  private
    def render_error(status, exception)
      respond_to do |format|
        format.html { render template: "errors/error_#{status}", layout: 'layouts/errors', status: status }
        format.all { render nothing: true, status: status }
      end
    end
end
