@ts = 
  parse_number_input: (text_field) ->
    if text_field.is('input')
      text_field.val(text_field.val().replace(',','.').replace('€',''))
      number = text_field.val().match(/-?\d+(.\d{1,4}){0,1}/g) || 0
      text_field.val(number)
    else
      number = text_field.html().replace(',','.').replace('€','')
    return number

jQuery ->
  $('.alert').alert()