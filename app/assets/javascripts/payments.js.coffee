# ------- Action listeners

select_user = () ->
  equal_percentage = get_equal_percentage()

  $('input.user-select:checked').each ->
    calculate_user_total($(this).parents('tr'), equal_percentage)

  $('input.user-select:not(:checked)').each ->
    calculate_user_total($(this).parents('tr'), 0)



update_percentage = (tb) ->
  percentage = ts.parse_number_input(tb)
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
    cost: parseFloat(ts.parse_number_input(user_hash['cost_field'])),
    paid: parseFloat(ts.parse_number_input(user_hash['paid_field']))
  return result

get_total_price = () ->
  ts.parse_number_input($('.total-price'))

get_equal_percentage = () ->
  number_selected_users = $('input.user-select:checked').size()
  return parseFloat(100 / number_selected_users).toFixed(window.payment_precision)

update_tb_state = (tb) ->
  user_object_hash = get_user_hash(tb.parents('tr'))
  if tb.is(':checked')
    user_object_hash['percentage_tb'].attr('disabled', false)
  else
    user_object_hash['percentage_tb'].attr('disabled', true)

calculate_user_total = (row, percentage) ->
  uh = get_user_hash(row)
  uh['percentage_tb'].val(percentage)
  if row.hasClass('current-user')
    uh['paid_field'].html('€ ' + get_total_price())
  else 
    uh['paid_field'].html('€ 0')
  uh['cost_field'].html('€ ' + (get_total_price() * (percentage / 100)).toFixed(window.payment_precision))
  vh = get_user_values(uh)
  uh['total_price_tb'].val(parseFloat(vh['paid'] - vh['cost']))

check_percentage = () ->
  sum = 0
  $('.user-price').each ->
    sum = sum + parseFloat(ts.parse_number_input($(this)))
  console.log(sum.toFixed(window.payment_precision))
  amount_is_zero = (-window.payment_max_deviation < sum.toFixed(window.payment_precision) < window.payment_max_deviation)
  $('input[type=submit]').attr('disabled', !amount_is_zero)

  $('input.user-select').parents('tr').find('.percentage').parents('div.control-group').each ->
    $(this).removeClass('error')

  unless amount_is_zero
    $('input.user-select:checked').parents('tr').find('.percentage').parents('div.control-group').each ->
      $(this).addClass('error')



jQuery ->
  $('.user-price').each ->
    $(this).attr('readonly', true)
  $('.user-select').each ->
    update_tb_state($(this))
    $(this).click ->
      update_tb_state($(this))
      select_user()
      check_percentage()
  $('.percentage').bind 'input', ->
    update_percentage($(this))
