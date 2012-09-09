jQuery ->
  $('#submit_button').click ->
    $('#submit_button').closest('form').submit()

jQuery ->
  $('.submit_community_user').each -> 
    $(this).click ->
      $(this).closest('tr').find('form').submit()