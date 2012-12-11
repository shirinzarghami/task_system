window.tasksystem = {};
window.tasksystem.show = (obj) ->
  obj.show('fold', {}, 500) unless obj.is(':visible')

window.tasksystem.hide = (obj) ->
  obj.hide('fold', {}, 500) unless obj.is(':hidden')