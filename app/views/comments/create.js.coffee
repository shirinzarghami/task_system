$('div.comments').append("<%= j render partial: 'comments/comment', object: @comment %>")
tinyMCE.activeEditor.setContent("")