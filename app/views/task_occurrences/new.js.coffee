$('div.container').append("<%= j render partial: 'form' %>")
$('#schedule-modal').modal()


$('.modal-destroy').each ->
  $(this).click -> 
    $('#schedule-modal').detach()
