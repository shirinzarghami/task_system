window.tasksystem = {};
window.tasksystem.show = (obj) ->
  obj.slideDown()

window.tasksystem.hide = (obj) ->
  obj.slideUp()

jQuery ->
  $('.alert').alert()