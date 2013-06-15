module PaymentsHelper
  def form_url
    if controller.action_name == 'update' || controller.action_name == 'edit'
      community_payment_path(@community, @payment.id)
    elsif controller.action_name == 'new'
      community_payments_path(@community)
    end
  end

  def payment_categories_for(payment)
    payment.categories_from(@community).first(5).map do |category|
      content_tag :span, category, class: 'badge'
    end.join.html_safe
  end
end
