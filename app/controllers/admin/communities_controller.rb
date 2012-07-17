class Admin::CommunitiesController < AdminController
  layout 'admin'

  def index
    @communities = Community.paginate page: params[:page], per_page: 25
  end

  def new
    @community = Community.new
  end

  def create
    @community = Community.new params[:community]

    if @community.save 
      flash[:notice] = "Successfully created"
      redirect_to admin_communities_path
    else
      render action: 'edit'
    end
  end

  def destroy
    
  end
end
