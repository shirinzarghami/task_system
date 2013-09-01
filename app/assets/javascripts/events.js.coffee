addRole = (obj) ->
  console.log('Test')

jQuery ->
  $('.add-role-buton').each ->
    $(this).on 'click', (event, object) ->
      addRole(object)
      event.preventDefault()
