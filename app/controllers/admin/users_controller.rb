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
    @user = User.new(params[:user])

   if params[:user][:password].blank?
     params[:user].delete(:password)
     params[:user].delete(:password_confirmation)
   end

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

    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update_attributes params[:user]
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


  # def apply_filter
  #   (params.has_key?(:filter) and FILTERS.has_key?(params[:filter].to_sym)) ? FILTERS[params[:filter].to_sym] : []
  # end

  # def filter_name
  #   params.has_key?(:filter) and FILTERS.has_key?(params[:filter].to_sym) ? params[:filter] : ''
  # end

  # def find_user
  #   (params.has_key? :query) ? ['email LIKE ?', "%#{params[:query]}%"] : []
  # end


end
