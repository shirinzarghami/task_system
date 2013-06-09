module PaymentsHelper
  def form_url
    if controller.action_name == 'edit'
      community_payment_path(@community, @payment)
    elsif controller.action_name == 'new'
      community_payments_path(@community)
    end
  end
end
