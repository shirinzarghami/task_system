class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :find_user
  def find_user
    @user = current_user
  end

  def find_community
    @community = @user.communities.find_by_subdomain! params.has_key?(:community_id) ? params[:community_id] : params[:id] if @user
    @community_user = CommunityUser.find_by_community_id_and_user_id!(@community, @user)
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
      @community_user and @community_user.role == 'admin'
    else
      CommunityUser.find_by_community_id_and_user_id!(community, @user).role == 'admin'
    end
  end

  def show_modal partial
    respond_to do |format|
      @partial = partial.to_s
      format.js {render 'shared/modal'}
    end
  end

  def error_messages_for object, flash = ""
    render_to_string('shared/errors.html', layout: false, formats: [:html], locals: {object: object, flash: flash}).html_safe
  end

  def after_sign_in_path_for(user)
    if user.communities.count == 1
      community_path user.communities.first
    else
      communities_path 
    end
  end

  def load_commentable
    klass = [TaskOccurrence].detect {|c| params["#{c.name.underscore}_id"]}
    @commentable = klass.find params["#{klass.name.underscore}_id"]
  end
end
