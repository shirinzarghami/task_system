class PaymentsController < ApplicationController
  add_crumb(lambda {|instance| instance.t('breadcrumbs.communities')}) { |instance| instance.send :communities_path }
  before_filter :find_community
  before_filter :set_breadcrumbs, except: [:update, :create, :destroy]
  before_filter :find_payment, except: [:index, :new, :create, :edit, :update]
  before_filter :new_payment, only: [:create]
  
  load_and_authorize_resource
  include Sortable::Controller
  sort :payment, default_column: :payed_at, default_direction: :desc

  def index
    @payments = @community.payments.joins("LEFT JOIN taggings ON taggings.taggable_id = payments.id AND taggings.taggable_type = 'Payment'").where(search_conditions).order(sort_column + ' ' + sort_direction).group('payments.id').paginate(page: params[:page], per_page: 20)

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
    @payment.build_repeatable_item

    @payment.repeatable_item.enabled = false
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
    @payment.repeatable_item.set_next_occurrence_from(@payment.payed_at)

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
    standard_params         = [:categories, :price, :payed_at, :description, :title]
    user_saldo_params       = [{:user_saldo_modifications_attributes => [:id, :checked, :percentage, :price, :community_user_id]}]
    repeatable_item_params  = [{:repeatable_item_attributes => [:deadline_number, :deadline_unit, :has_deadline, :next_occurrence, :only_on_week_days, :repeat_every_number, :repeat_every_unit, :repeat_infinite, :repeat_every_number]}]

    params.require(:payment).permit *(standard_params + repeatable_item_params + user_saldo_params)
  end

  def find_payment
    @object ||= @payment ||= Payment.find(params.has_key?(:payment_id) ? params[:payment_id] : params[:id])
    add_crumb(@payment.title.truncate(10), community_payment_path(@community, @payment))
  end

  def new_payment
    @payment = @community_user.payments.build payment_params
  end

  def search_conditions
    if params.has_key?(:q) && params[:q].present?
      @search_tag = ActsAsTaggableOn::Tag.find_by_name params[:q]

      search = "%#{params[:q]}%"
      conditions = ['title LIKE ?', 'description LIKE ?', ("taggings.tag_id = ?" if @search_tag)].compact.join(' OR ')
      values = [search, search, (@search_tag.id if @search_tag)].compact
      [conditions, values].flatten
    end
  end

end
