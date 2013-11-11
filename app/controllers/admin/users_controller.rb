class Admin::UsersController < AdminController

  def index
    @filter = filter_name
    @users = User.paginate page: params[:page], per_page: 25, conditions: apply_filter + find_community
    respond_to do |format|
      format.html
      format.js
      format.json {render json: User.where('email like ?', "%#{params[:q]}%")}
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:notice] = t('messages.save_success')
      redirect_to admin_users_path
    else
      flash[:error] = t('messages.save_fail')
      render action: 'new'
    end
  end

  def edit
    @user = User.find params[:id]
  end

  def update
     @user = User.find(params[:id])

    if @user.update_attributes user_params
     flash[:notice] = t('messages.save_success')
     redirect_to admin_users_path
    else
     flash[:error] = t('messages.save_fail')
     render action: 'edit'
    end

  end

  def destroy
    User.find(params[:id]).destroy
    flash[:notice] = t('messages.delete')
    redirect_to admin_users_path
  end

  protected
  def user_params
    params.require(:user).permit(:email, :global_role, :name, :locale, :password, :password_confirmation)
  end

end
