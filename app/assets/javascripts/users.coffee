# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  hash = window.location.hash
  $('.tab-display > ul > li > a[href="' + hash + '"]').tab('show')
  
  $('#user_image_url').bind "change", ->
    size_in_megabytes = this.files[0].size/1024/1024
    if size_in_megabytes > 5
      alert('Maximum file size is 5MB. Please choose a smaller file.')
    return
  $('.pagination > ul > li > a').on "click", (e) ->
    e.preventDefault
    loc = $(this).closest('.active')
    id = $(loc).attr('id')
    new_loc = $(this).attr('href') + "#" + id
    location.href = new_loc
    return false
  return