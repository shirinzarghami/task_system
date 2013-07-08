class PaymentsController < ApplicationController
  load_and_authorize_resource
  add_crumb(lambda {|instance| instance.t('breadcrumbs.communities')}) { |instance| instance.send :communities_path }
  before_filter :find_community
  before_filter :set_breadcrumbs, except: [:update, :create, :destroy]
  before_filter :find_payment, except: [:index, :new, :create, :edit, :update]

  include Sortable::Controller
  sort :payment, default_column: :date, default_direction: :asc

  def index
    @payments = @community.payments.where(search_conditions).order(sort_column + ' ' + sort_direction).paginate(page: params[:page], per_page: 20)
    # if params[:q].present?
    #   @tagged_payment = @community.payments.tagged_with(params[:q].split(' '), any: true, wild: true) 
    #   @payments << @tagged_payment
    # end
    # debugger
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @comment = Comment.build_from(@payment, current_user.id, '')
    @comments = @payment.root_comments.paginate(page: params[:page], per_page: 10)
  end

  def edit
    add_crumb(t('breadcrumbs.edit'), new_community_task_path(@community))
  end

  def new
    add_crumb(t('breadcrumbs.new'), new_community_task_path(@community))
    @payment = ProductDeclaration.new
    @community.community_users.each {|co| @payment.user_saldo_modifications.build community_user: co}  
  end

  def update
    if @payment.update_attributes payment_params
      @payment.save_category_tags
      flash[:notice] = t('messages.save_success')
      redirect_to community_payments_path @community
    else
      flash[:error] = t('messages.save_fail')
      render action: 'edit'
    end
  end

  def create
    @payment = @community_user.payments.build payment_params
    @payment.becomes(ProductDeclaration)
    if @payment.save
      @payment.save_category_tags
      flash[:notice] = t('messages.save_success')
      redirect_to community_payments_path @community
    else
      flash[:error] = t('messages.save_fail')
      render 'edit'
    end
  end

  def destroy
    if @payment.destroy
      flash[:notice] = t('messages.task_destroy_success')
      redirect_to community_payments_path @community
    else
      flash[:error] = t('messages.task_destroy_fails')
      redirect_to community_payments_path @community
    end
  end

  private
    def set_breadcrumbs
      set_community_breadcrumb
      add_crumb t('breadcrumbs.payments'), community_payments_path(@community)
    end

    def payment_params
      if params.has_key? :payment
        params.require(:payment).permit(:categories, :price, :date, :description, :title, :type, {user_saldo_modifications_attributes: [:id, :checked, :percentage, :price, :community_user_id, :payment_id]})
      elsif params.has_key? :product_declaration
        params.require(:product_declaration).permit(:categories, :price, :date, :description, :title, :type, {user_saldo_modifications_attributes: [:id, :checked, :percentage, :price, :community_user_id, :payment_id]})
      end
    end

    def find_payment
      @object ||= @payment ||= Payment.find(params.has_key?(:payment_id) ? params[:payment_id] : params[:id])
      add_crumb(@payment.title.truncate(10), community_payment_path(@community, @payment))
    end

    def search_conditions
      if params.has_key?(:q) && params[:q].present?
        search = "%#{params[:q]}%"
        ['title LIKE ? OR description LIKE ?', search, search]
      end
    end
end
