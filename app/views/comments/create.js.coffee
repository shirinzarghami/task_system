$('div.comments').append("<%= j render partial: 'comments/comment', object: @comment %>")
$('#comment_body').val('')