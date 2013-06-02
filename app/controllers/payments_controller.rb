class PaymentsController < ApplicationController
  add_crumb(lambda {|instance| instance.t('breadcrumbs.communities')}) { |instance| instance.send :communities_path }
  before_filter :find_community
  before_filter :set_payment_breadcrumb, except: [:update, :create, :destroy]
  def index
    @payments = @community.payments.paginate(page: params[:page], per_page: 20)
  end

  def show
  end

  def edit
    add_crumb(t('breadcrumbs.edit'), new_community_task_path(@community))
    @payment = Payment.find(params[:id])
  end

  def new
    add_crumb(t('breadcrumbs.new'), new_community_task_path(@community))
    @payment = ProductDeclaration.new
    @community.community_users.each {|co| @payment.user_saldo_modifications.build community_user: co}  
  end

  def update
  end

  def create
    @payment = ProductDeclaration.new payment_params.merge community_user_id: @community_user.id
    if @payment.save
      flash[:notice] = t('messages.save_success')
      redirect_to community_payments_path @community
    else
      flash[:error] = t('messages.save_fail')
      render 'new'
    end
  end

  def destroy
  end

  private
    def set_payment_breadcrumb
      add_crumb t('breadcrumbs.payments'), community_payments_path(@community)
    end

    def payment_params
      if params.has_key? :payment
        params.require(:payment).permit(:date, :description, :title, :type, {user_saldo_modifications_attributes: [:checked, :percentage, :price, :community_user_id, :payment_id]})
      elsif params.has_key? :product_declaration
        params.require(:product_declaration).permit(:date, :description, :title, :type, {user_saldo_modifications_attributes: [:checked, :percentage, :price, :community_user_id, :payment_id]})
      end
    end
end
