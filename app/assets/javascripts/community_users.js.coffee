# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

graph_label_formatter = (value) ->
  return value + " " + $('#user-timeline').data('translation').minutes

jQuery ->
  $('form.edit_community_user').each ->
    $(this).change ->
      $(this).submit()


  if ($('#user-timeline').length)
    Morris.Area
      element: 'user-timeline',
      data: $('#user-timeline').data('distribution'),
      xkey: 'date',
      ykeys: $('#user-timeline').data('labels'),
      labels: $('#user-timeline').data('labels'),
      yLabelFormat: graph_label_formatter,
      hideHover: true