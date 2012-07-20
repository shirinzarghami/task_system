class Admin::UsersController < AdminController
  def index
    @users = User.paginate page: params[:page], per_page: 25
    respond_to do |format|
      format.html
      format.json {render json: User.where('email like ?', "%#{params[:q]}%")}
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

   if params[:user][:password].blank?
     params[:user].delete(:password)
     params[:user].delete(:password_confirmation)
   end

   if @user.save
    flash[:notice] = "User has been saved"
    redirect_to admin_users_path
   else
    flash[:error] = "Could not save the user"
    render action: 'new'
   end
  end

  def edit
    @user = User.find params[:id]
  end

  def update
     @user = User.find(params[:id])

    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update_attributes params[:user]
     flash[:notice] = "User has been saved"
     redirect_to admin_users_path
    else
     flash[:error] = "Could not save the user"
     render action: 'edit'
    end

  end

  def destroy
    User.find(params[:id]).destroy
    flash[:notice] = "User has been deleted"
    redirect_to admin_users_path
  end
end
