@ts = 
  parse_number_input: (text_field) ->
    if text_field.is('input')
      text_field.val(text_field.val().replace(',','.').replace('€',''))
      number = text_field.val().match(/-?\d+(.\d+){0,1}/g) || 0
      text_field.val(number)
    else
      number = text_field.html().replace(',','.').replace('€','')
    return number

  toggleShow: (src_obj, animate = true) ->
    obj_name = src_obj.data('toggle-visibility-of')
    obj = $('#' + obj_name) #Find by ID
    obj = src_obj.closest('tr, div').find('.' + obj_name).first() if obj.length == 0  # Find by class if no ID is found
    
    if src_obj.attr('checked')
      if animate then obj.slideDown() else obj.show()
    else
      if animate then obj.slideUp() else obj.hide()

  bindToggleVisibility: () ->
    $("[data-toggle-visibility-of]").each ->
      ts.toggleShow($(this), false)

    $("[data-toggle-visibility-of]").click (event) ->
      ts.toggleShow($(this))

jQuery ->
  ts.bindToggleVisibility()

  $('.alert').alert()

  $('input.datepicker').each ->
    $(this).datepicker
      dateFormat: 'yy-mm-dd'

  $('input.datetimepicker').each ->
    $(this).datetimepicker()
