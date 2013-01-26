class RegistrationsController < Devise::RegistrationsController
  before_filter :check_register_on, only: [:new, :create]

  layout :get_layout
  def new
    @user = User.new
  end

  def create
    @user = User.new params[:user]

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

end
