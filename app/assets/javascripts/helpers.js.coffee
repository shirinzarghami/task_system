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
    obj_name = $(this).data('toggle-visibility-of')
    obj = $('#' + obj_name) #Find by ID
    obj = $(this).closest('tr, div').find('.' + obj_name).first() if obj.length == 0  # Find by class if no ID is found
    console.log(obj_name)
    
    if $(this).attr('checked')
      obj.slideDown()
    else
      obj.slideUp()

  $("[data-toggle-visibility-of]").each ->
    obj_name = $(this).data('toggle-visibility-of')

    obj = $('#' + obj_name) #Find by ID
    if obj.is(':visible')
      obj.hide() unless $(this).attr('checked')
    else
      obj.show() if $(this).attr('checked')

  $('input.datepicker').each ->
    $(this).datepicker
      dateFormat: 'yy-mm-dd'

  $('input.datetimepicker').each ->
    $(this).datetimepicker()
