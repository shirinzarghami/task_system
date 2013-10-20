class StartSaldoDistributionsController < ApplicationController
  add_crumb(lambda {|instance| instance.t('breadcrumbs.communities')}) { |instance| instance.send :communities_path }
  before_filter :find_community
  before_filter :set_breadcrumbs

  def edit
    @start_saldo_distribution = @community.start_saldo_distribution
  end

  def update
    @start_saldo_distribution = @community.start_saldo_distribution

    if @start_saldo_distribution.update_attributes start_saldo_params
      flash[:notice] = t('messages.save_success')
      redirect_to community_tasks_path @community
    else
      flash[:error] = t('messages.save_fail')
      render action: 'edit'
    end
  end

  protected
  def set_breadcrumbs
    set_community_breadcrumb
    add_crumb t('breadcrumbs.start_saldo_distribution'), community_tasks_path(@community)
  end

  def start_saldo_params
    params.require(:start_saldo_distribution).permit({user_saldo_modifications_attributes: [:id, :price, :community_user_id,]})
  end

end