# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$.fn.setPaginateLink = ->
  this.each ->
    append = this.getAttribute("id")
    links = $(this).find("ul.pagination > li >a")
    links.each ->
      _href = this.getAttribute("href").replace(/#\S*$/, "")
      $(this).attr("href", _href + "#" + append)
      return
    return

$ ->
  $(".tab-pane").setPaginateLink()
  if location.hash
    $('.tab-display > ul > li > a[href=" + location.hash + "]').tab('show')
  $("a[data-toggle=tab]").on "click", (e) ->
    location.hash = this.getAttribute("href")
    return
    
  $('#user_image_url').bind "change", ->
    size_in_megabytes = this.files[0].size/1024/1024
    if size_in_megabytes > 5
      alert('Maximum file size is 5MB. Please choose a smaller file.')
    return
    
$(window).on 'popstate', ->
  anchor = location.hash || $("a[data-toggle=tab]").first().attr("href")
  $('.tab-display > ul > li > a[href=' + anchor + ']').tab('show')
  return