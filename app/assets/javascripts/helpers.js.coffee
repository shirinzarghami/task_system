@ts = 
  parse_number_input: (text_field) ->
    if text_field.is('input')
      text_field.val(text_field.val().replace(',','.').replace('€',''))
      number = text_field.val().match(/-?\d+(.\d+){0,1}/g) || 0
      text_field.val(number)
    else
      number = text_field.html().replace(',','.').replace('€','')
    return number

jQuery ->
  $('.alert').alert()

  $("[data-toggle-visibility-of]").click ->
    obj = $('#' + $(this).data('toggle-visibility-of'))
    if $(this).attr('checked')
      obj.slideDown()
    else
      obj.slideUp()

  $("[data-toggle-visibility-of]").each ->
    obj = $('#' + $(this).data('toggle-visibility-of'))

    if obj.is(':visible')
      obj.hide() unless $(this).attr('checked')
    else
      obj.show() if $(this).attr('checked')
