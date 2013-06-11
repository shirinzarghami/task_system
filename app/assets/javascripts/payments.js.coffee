# ------- Action listeners

select_user = () ->
  equal_percentage = get_equal_percentage()

  $('input.user-select:checked').each ->
    calculate_user_total($(this).parents('tr'), equal_percentage)

  $('input.user-select:not(:checked)').each ->
    calculate_user_total($(this).parents('tr'), 0)



update_percentage = (tb) ->
  percentage = ts.parse_number_input(tb)
  tb.prev().val(percentage)
  tb.val(get_equal_percentage()) unless (0 <= percentage <= 100) 

  row = tb.parents('tr')
  calculate_user_total(row, percentage)
  check_percentage()    

# --------- Helpers
get_user_hash = (row_obj) ->
  result = 
    total_price_tb: row_obj.find('td div input.user-price'),
    percentage_tb: row_obj.find('td div input.percentage'),
    cost_field: row_obj.find('td.cost'),
    paid_field: row_obj.find('td.paid')
  return result

get_user_values = (user_hash) ->
  result = 
    total_price: parseFloat(ts.parse_number_input(user_hash['total_price_tb'])),
    percentage: parseFloat(ts.parse_number_input(user_hash['percentage_tb'])),
    cost: parseFloat(user_hash['cost_field'].data('cost')),
    paid: parseFloat(user_hash['paid_field'].data('paid'))
  return result

get_total_price = () ->
  ts.parse_number_input($('.total-price'))

get_equal_percentage = () ->
  number_selected_users = $('input.user-select:checked').size()
  return parseFloat(100 / number_selected_users).toFixed(window.payment_precision)

update_tb_state = (cb) ->
  # user_object_hash = get_user_hash(cb.parents('tr'))
  tb = cb.parents('tr').find('.percentage-input')
  if cb.is(':checked')
    tb.attr('readonly', false)
  else
    tb.attr('readonly', true)

calculate_user_total = (row, percentage) ->
  uh = get_user_hash(row)
  uh['percentage_tb'].val(percentage)
  if row.hasClass('current-user')
    uh['paid_field'].data('paid', get_total_price())
  else 
    uh['paid_field'].data('paid', '0')
  uh['cost_field'].data('cost', (get_total_price() * (percentage / 100)).toFixed(window.payment_precision))
  vh = get_user_values(uh)
  uh['total_price_tb'].val(parseFloat(vh['paid'] - vh['cost']))
  update_visible_fields()

check_percentage = () ->
  sum = 0
  $('.user-price').each ->
    sum = sum + parseFloat(ts.parse_number_input($(this)))
  amount_is_zero = (-window.payment_max_deviation < sum.toFixed(window.payment_precision) < window.payment_max_deviation)
  $('input[type=submit]').attr('disabled', !amount_is_zero)

  $('input.user-select').parents('tr').find('.percentage').parents('div.control-group').each ->
    $(this).removeClass('error')

  unless amount_is_zero
    $('input.user-select:checked').parents('tr').find('.percentage').parents('div.control-group').each ->
      $(this).addClass('error')

update_visible_fields = () ->
  $('.user-saldo-modification').each ->
    $(this).find('.percentage-input:not(:focus)').val(parseFloat($(this).find('.percentage').val()).toFixed(2))
    $(this).find('.price-input').val(parseFloat($(this).find('.user-price').val()).toFixed(2))
    $(this).find('.cost').html('€ ' + parseFloat($(this).find('.cost').data('cost')).toFixed(2))
    $(this).find('.paid').html('€ ' + parseFloat($(this).find('.paid').data('paid')).toFixed(2))

update_invisible_fields = () ->
  $('.user-saldo-modification').each ->
    $(this).find('.percentage').val(parseFloat($(this).find('.percentage-input').val()).toFixed(2))
    $(this).find('.user-price').val(parseFloat($(this).find('.price-input').val()).toFixed(2))
    $(this).find('.cost').data('cost', parseFloat($(this).find('.cost').html()).toFixed(2))
    $(this).find('.paid').data('paid', parseFloat($(this).find('.paid').html()).toFixed(2))


jQuery ->
  $('.price-input').each ->
    $(this).attr('readonly', true)
  $('.user-select').each ->
    update_tb_state($(this))
    $(this).click ->
      update_tb_state($(this))
      select_user()
      check_percentage()
  $('.percentage-input').bind 'input', ->
    update_percentage($(this))
  $('.percentage').each ->
    update_percentage($(this))
  update_visible_fields()
