# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  # $('#community_user_tokens').tokenInput document.location.origin + '/admin/users.json' $(location).attr('href')
  $('#community_user_tokens').tokenInput users_url,
    theme: 'facebook'
    propertyToSearch: 'email'
    preventDuplicates: true

  $('#community_admin_user_tokens').tokenInput users_url,
    theme: 'facebook'
    propertyToSearch: 'email'

  $('#community_name').keyup ->
    text = makeValidSubdomain($('#community_name').val())
    $('#community_subdomain').val(text)

makeValidSubdomain = (text) -> text.toLowerCase().replace /[^a-zA-Z0-9-_]/g, "-"
