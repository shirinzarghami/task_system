jQuery ->
  $('#submit_button').click ->
    $('#submit_button').closest('form').submit()