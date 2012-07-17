class Admin::CommunitiesController < AdminController
  layout 'admin'

  def index
    @communities = Community.paginate page: params[:page], per_page: 25
  end
end
