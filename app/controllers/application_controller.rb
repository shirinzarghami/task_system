class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :find_user
  before_filter :find_community
  def find_user
    @user = current_user
  end

  def find_community
    @community = @user.communities.find_by_subdomain params.has_key?(:community_id) ? params[:community_id] : params[:id]
  end
end
