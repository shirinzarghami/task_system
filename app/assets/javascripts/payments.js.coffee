# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

user_select = () ->
  number_selected = $('input.user-select:checked').size()
  price = $('#product_declaration_price').val().match(/\d+(.\d{1,2}){0,1}/g)

  $('input.user-select:checked').each ->
    row = $(this).parents('tr') 

    row.find('td.cost').html('€ ' + (-1 * price / number_selected))
    row.find('td div input.percentage').val(100 / number_selected)
    if row.hasClass('current-user')
      row.find('td.paid').html('€ ' + price)
    update_user_total(row)

  $('input.user-select:not(:checked)').each ->
    row = $(this).parents('tr') 

    row.find('td.cost').html('€ 0')
    row.find('td div input.percentage').val('0')
    row.find('td.paid').val('€ 0')
    update_user_total(row)

update_user_total = (row) ->
  cost = parseFloat(row.find('td.cost').html().replace('€', ''))
  paid = parseFloat(row.find('td.paid').html().replace('€', ''))
  row.find('td div input.total').val(cost + paid)


jQuery ->
  $('.user-select').each ->
    $(this).click ->
      user_select()

  $('#product_declaration_price').bind 'input', ->
    user_select()