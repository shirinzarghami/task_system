class Admin::UsersController < AdminController
  def index
    respond_to do |format|
      format.json {render json: User.where('email like ?', "%#{params[:q]}%")}
    end
  end

  def new
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
