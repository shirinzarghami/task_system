# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('input.datepicker').each ->
    $(this).datepicker()

  $('#auto_instantiation_no').click ->
    if $('#instantiation_options').is(":visible")
      $('#instantiation_options').hide("fold", {}, 500);

  $('#auto_instantiation_yes').click ->
    if $('#instantiation_options').is(":hidden")
      $('#instantiation_options').show("fold", {}, 500);