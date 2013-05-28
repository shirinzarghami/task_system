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
  end

  def new
    add_crumb(t('breadcrumbs.new'), new_community_task_path(@community))
    @payment = ProductDeclaration.new
    @community.community_users.each {|co| @payment.user_saldo_modifications.build community_user: co}  
  end

  def update
  end

  def create
  end

  def destroy
  end

  private
    def set_payment_breadcrumb
      add_crumb t('breadcrumbs.payments'), community_payments_path(@community)
    end
end
