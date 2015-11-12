# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#recipe_image_url').bind "change", ->
    size_in_megabytes = this.files[0].size/1024/1024
    if size_in_megabytes > 5 then alert('Maximum file size is 5MB. Please choose a smaller file.')