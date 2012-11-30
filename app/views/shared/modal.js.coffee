$('div.container').append("<%= j render partial: @partial %>")
$('#schedule-modal').modal()


$('.modal-destroy').each ->
  $(this).click -> 
    $('#schedule-modal').detach()

$('.submit').each ->
  $(this).click ->
    $('form').first().submit()