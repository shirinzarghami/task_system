class RegistrationsController < Devise::RegistrationsController
  before_filter :check_register_on, only: [:new, :create]
  layout :get_layout
  
  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation, :remember_me, :name, :locale, :avatar,:receive_comment_mail, :receive_assign_mail, :receive_reminder_mail)
  end
  private :resource_params
  
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:notice] = t('messages.registrations.success')
    else
      render 'new'
    end
  end

  protected
    def check_register_on
      unless CONFIG[:registration_allowed]
        flash[:error] = t('messages.registrations.turned_off')
        redirect_to new_user_session_path
      end
    end

    def get_layout
      if current_user
        "application"
      else
        "registrations"
      end
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :remember_me, :name, :locale, :avatar,:receive_comment_mail, :receive_assign_mail, :receive_reminder_mail)
    end

end
