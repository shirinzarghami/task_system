# Add a new row before the last row. Clear the text fields of the last one
addRole = (event) ->
  event.preventDefault()

  event_role = $(event.target).parents('tr.event-role')
  $('#role-table tr:nth-last-child(2)').after(event_role.clone())

  $('.remove-role-button:not(:last)').each ->
    $(this).show()
    $(this).click(removeRole)

  $('.add-role-button:not(:last)').hide()
  clearLastRole()
  updateFieldNames()
  ts.bindToggleVisibility()



clearLastRole = () ->
  $('tr.event-role:last input, tr.event-role:last select').val('')
  $('tr.event-role:last input[type=checkbox]').attr('checked', false)

updateFieldNames = () ->
  $('tr.event-role').each (id) ->
    $(this).find('input, select').each ->
      between_brackets = $(this).attr('name').match(/\[(.*?)\]/gi)
      attribute_name = between_brackets[between_brackets.length - 1].replace(/\[|\]/gi, '')
      $(this).attr('name', 'repeatable_event[event_role]' + '[' + id  + '][' + attribute_name + ']') 

removeRole = (event) ->
  event.preventDefault()
  $(event.target).parents('tr.event-role').remove()


jQuery ->
  $('.add-role-button').click(addRole)