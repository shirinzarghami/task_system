addRole = () ->
  latest_event_role = $("[data-event-role-number]").last()

  number_of_roles = parseInt(latest_event_role.data('event-role-number'))
  cloned_event_role = latest_event_role.clone()
  cloned_event_role.hide()
  cloned_event_role.appendTo('#role-table')

  cloned_event_role.data('event-role-number', number_of_roles + 1)
  cloned_event_role.find('.remove-role-buton').show()
  latest_event_role.find('.add-role-buton').remove()
  bindAddRoleButton(cloned_event_role.find('.add-role-buton'))
  bindRemoveRoleButton(cloned_event_role.find('.remove-role-buton'))

  cloned_event_role.slideDown(400)

removeRole = (obj) ->
  event_role = obj.parents('tr')
  event_roles = $("[data-event-role-number]")
  latest_event_role = event_roles.last()
  second_latest_event_role = event_roles[event_roles.length - 2]

  if event_role[0] == latest_event_role[0]
    console.log('Last role')
    latest_event_role.find('.add-role-buton').clone().appendTo(second_latest_event_role.find('.event-role-actions'))

  event_role.slideUp 400, ->
    event_role.remove()

bindAddRoleButton = (obj) ->
  obj.on 'click', (event, object) ->
    event.preventDefault()
    addRole()

bindRemoveRoleButton = (obj) ->
  obj.on 'click', () ->
    event.preventDefault()
    removeRole(obj)
  




jQuery ->
  $('.add-role-buton:last').each ->
    bindAddRoleButton($(this))

  $('.remove-role-buton').hide()
