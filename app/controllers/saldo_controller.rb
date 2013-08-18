class SaldoController < ApplicationController
  before_filter :find_community

  def show
    @saldos = @community.user_saldo_modifications.group(:community_user_id).sum(:price)
    @error = @community.user_saldo_modifications.sum(:price)
  end
end
