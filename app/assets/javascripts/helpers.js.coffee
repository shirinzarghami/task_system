# window.tasksystem = {};
# window.tasksystem.show = (obj) ->
#   obj.slideDown()

# window.tasksystem.hide = (obj) ->
#   obj.slideUp()

@ts = 
  parse_number_input: (text_field) ->
    if text_field.is('input')
      text_field.val(text_field.val().replace(',','.').replace('€',''))
      number = text_field.val().match(/-?\d+(.\d{1,4}){0,1}/g) || 0
      text_field.val(number)
    else
      number = text_field.html().replace(',','.').replace('€','')
    return number





  # disable_object: (object, condition) ->
  #   if condition
  #     object.attr('disabled', true)
jQuery ->
  $('.alert').alert()