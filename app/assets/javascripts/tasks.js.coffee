# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
show_allocation_tag = (name) ->
  $('.allocation_tab').each -> 
    $(this).show() if $(this).attr('id') == name
    $(this).hide() if $(this).attr('id') != name

update_instantiation = (chkbox) ->
  if chkbox.attr('checked')
    tasksystem.show($('#instantiation_options'))
  else
    tasksystem.hide($('#instantiation_options'))

jQuery ->
  #  ---- New task form dynamics
  $('#tasks-tab a').each ->
    $(this).click ->
      $(this).tab('show')

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

  # Global
  $('.tooltip-link').each ->
    $(this).tooltip()

  # Donut graph task#show
  Morris.Donut({
    element: 'task-donut',
    data: [
      {label: "Download Sales", value: 12},
      {label: "In-Store Sales", value: 30},
      {label: "Mail-Order Sales", value: 20}
    ]
  });

