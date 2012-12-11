@show = (obj) ->
  obj.show('fold', {}, 500) unless obj.is(':visible')

@hide = (obj) ->
  obj.hide('fold', {}, 500) unless obj.is(':hidden')