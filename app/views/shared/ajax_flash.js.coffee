$('div#flash-container').slideUp ->
  $('div#flash-container').html("")
  $('div#flash-container').append("<%= j render partial: 'shared/ajax_flash' %>")
  $('div#flash-container').slideDown()