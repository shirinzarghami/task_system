# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
show_allocation_tag = (name) ->
  $('.allocation_tab').each -> 
    $(this).show() if $(this).attr('id') == name
    $(this).hide() if $(this).attr('id') != name

update_instantiation = (chkbox, animate = true) ->
  obj = $('#instantiation_options')
  if chkbox.attr('checked')
    if animate then obj.slideDown() else obj.show()
  else
    if animate then obj.slideUp() else obj.hide()
    # tasksystem.hide($('#instantiation_options'))

donut_formatter = (value) ->
  minutes = value % 60
  if (minutes < 10)
    minutes = '0' + minutes 
  return parseInt(value / 60) + ':' + minutes + 'h'

ignored_user_updater = () ->

jQuery ->
  #  ---- New task form dynamics
  $('#tasks-tab a').each ->
    $(this).click ->
      $(this).tab('show')

  update_instantiation $('#task_instantiate_automatically'), false

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
      user_order = $('#task_ordered_user_ids')
      user_order.val('')
      ignored_users = $('#task_ignored_user_ids')
      ignored_users.val('')

      $('li.separator').nextAll('.sort-item').each ->
        $(this).addClass('ignored-user')

      $('li.separator').previousAll('.sort-item').each ->
        $(this).removeClass('ignored-user')

      $('.sort-item:not(.ignored-user)').each ->
        user_order.val(user_order.val() + $(this).attr('user_id') + ',')

      $('.ignored-user').each ->
        ignored_users.val(ignored_users.val() + $(this).attr('user_id') + ',')


  # Global
  $('.tooltip-link').each ->
    $(this).tooltip()

  # Donut graph task#show
  if $('#task-donut').length > null
    Morris.Donut
      element: 'task-donut',
      data: $('#task-donut').data('distribution'),
      colors: ['#E0FA71', '#E7003E', '#560EAD', '#9DB82E', '#F33D6E', '#8643D6'],
      formatter: donut_formatter


