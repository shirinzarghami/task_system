# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

update_create_user_tab = (optionbox) ->
  if $('#user-form') && optionbox.attr('value') == 'accept' && optionbox.attr('checked')
    tasksystem.show($('#user-form'))
  else
    tasksystem.hide($('#user-form'))

jQuery ->
  $('#user-form').hide()
  $('#invitation_accept').click ->
    update_create_user_tab $(this)

  $('#invitation_deny').click ->
    update_create_user_tab $(this)
