# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

set_initial_values = () ->
  $('.percentage').each ->
    $(this).attr('disabled', true)

  $('.update_user_total').each ->
    $(this).attr('disabled', true)

user_select = () ->
  number_selected = $('input.user-select:checked').size()
  price = ts.parse_number_input($('#product_declaration_price'))

  $('input.user-select:checked').each ->
    row = $(this).parents('tr') 
    percentage_input = row.find('td div input.percentage')
    price_input = row.find('td div input.total')
    percentage_input.attr("disabled", false)
    price_input.attr("disabled", false)
    row.find('td.cost').html('€ ' + (-1 * price / number_selected).toFixed(2))
    percentage_input.val((100 / number_selected).toFixed(2))
    if row.hasClass('current-user')
      row.find('td.paid').html('€ ' + price)
    update_user_total(row)

  $('input.user-select:not(:checked)').each ->
    row = $(this).parents('tr') 
    percentage_input = row.find('td div input.percentage')
    price_input = row.find('td div input.total')
    percentage_input.attr("disabled", true)

    price_input.attr("disabled", true)
    row.find('td.cost').html('€ 0')
    row.find('td div input.percentage').val('0')
    row.find('td.paid').val('€ 0')
    update_user_total(row)

update_user_total = (row) ->
  cost = parseFloat(row.find('td.cost').html().replace('€', ''))
  paid = parseFloat(row.find('td.paid').html().replace('€', ''))
  row.find('td div input.total').val(cost + paid)

percentage_update = (changed_input_box) ->
  percentage = ts.parse_number_input(changed_input_box)
  number_selected = $('input.user-select:checked').size()
  remaining_percentage = ((100 - percentage) / (number_selected - 1)).toFixed(2)
  $('.percentage:not(#' + changed_input_box.attr('id') + '):not([disabled])').each ->
    $(this).val(remaining_percentage)

calculate_totals = () ->


jQuery ->
  set_initial_values()
  $('.user-select').each ->
    $(this).click ->
      user_select()

  $('#product_declaration_price').bind 'input', ->
    user_select()

  $('.percentage').each ->
    $(this).bind 'input', ->
      percentage_update($(this))