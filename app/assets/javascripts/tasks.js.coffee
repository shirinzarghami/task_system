# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('input.datepicker').each ->
    $(this).datepicker()

  $('#auto_instantiation_no').click ->
    if $('#instantiation_options').is(":visible")
      $('#instantiation_options').hide("fold", {}, 500)

  $('#auto_instantiation_yes').click ->
    if $('#instantiation_options').is(":hidden")
      $('#instantiation_options').show("fold", {}, 500)

  $('#task_repeat_infinite').click ->    
    if $(this).attr('checked')
      $('#task_repeat').attr("disabled","disabled")
    else
      $('#task_repeat').removeAttr("disabled")

  $('#task_allocation_mode').click ->
    show_allocation_tag('allocation_user') if $('#task_allocation_mode').val() == 'user'
    show_allocation_tag('allocation_order') if $('#task_allocation_mode').val() == 'in_turns'

show_allocation_tag name ->
  $('.allocation_tab').each -> 
    $(this).show("fold", {}, 500) if ($(this).attr('id') == name && $(this).is(':visible'))
    $(this).hide("fold", {}, 500) if ($(this).attr('id') != name && $(this).is(':hidden'))
