class Admin::CommunitiesController < AdminController
  layout 'admin'

  def index
    @communities = Community.paginate page: params[:page], per_page: 25
  end

  def new
    @community = Community.new
  end

  def create
    
  end

  def destroy
    
  end
end
