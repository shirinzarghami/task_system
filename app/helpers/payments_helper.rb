module PaymentsHelper
  def payment_form_url
    if controller.action_name == 'update' || controller.action_name == 'edit'
      community_payment_path(@community, @payment.id)
    elsif controller.action_name == 'new' || controller.action_name == 'create'
      community_payments_path(@community)
    end
  end

  def payment_categories_for(payment)
    payment.categories_from(@community).first(5).map do |category|
      content_tag :span, category, class: 'badge'
    end.join.html_safe
  end

  def payment_distribution
    @payment.user_saldo_modifications.map {|sm| {label: sm.user.name, value: sm.percentage.to_i}}.to_json
  end
end
