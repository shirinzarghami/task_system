# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
show_allocation_tag = (name) ->
  $('.allocation_tab').each -> 
    $(this).show() if $(this).attr('id') == name
    $(this).hide() if $(this).attr('id') != name

show = (obj) ->
  obj.show('fold', {}, 500) unless obj.is(':visible')

hide = (obj) ->
  obj.hide('fold', {}, 500) unless obj.is(':hidden')

update_instantiation = (chkbox) ->
  if chkbox.attr('checked')
    show($('#instantiation_options'))
  else
    hide($('#instantiation_options'))

jQuery ->
  update_instantiation $('#task_instantiate_automatically')
  show_allocation_tag($('#task_allocation_mode').val() + '_tab')
  $('input.datepicker').each ->
    $(this).datepicker
      dateFormat: 'yy-mm-dd'
  $('#task_instantiate_automatically').click ->
    update_instantiation $(this)
    

  $('#task_repeat_infinite').click ->    
    if $(this).attr('checked')
      $('#task_repeat').attr("disabled","disabled")
    else
      $('#task_repeat').removeAttr("disabled")

  $('#task_allocation_mode').click ->
    show_allocation_tag($('#task_allocation_mode').val() + '_tab')

  $('#user-sorter').sortable
    update: ->
      text_box = $('#task_user_order')
      text_box.val('')
      $('.sort-item').each ->
        text_box.val(text_box.val() + $(this).attr('user_id') + ',')
