# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
  
  moveIt = undefined

  moveIt = (direction, target) ->
    targetDiv = undefined
    targetDiv = $(this).closest(target)
    if direction == 'up'
      targetDiv.insertBefore targetDiv.prevAll(target.concat(':first'))
    else if direction == 'down'
      targetDiv.insertAfter targetDiv.nextAll(target.concat(':first'))
    return

  $('#recipe_image_url').bind "change", ->
    size_in_megabytes = this.files[0].size/1024/1024
    if size_in_megabytes > 5 then alert('Maximum file size is 5MB. Please choose a smaller file.')

  $('#steps')
    .on "cocoon:before-remove", (e, step) ->
      $(this).data 'remove-timeout', 1000
      step.fadeOut "slow"
    .on "cocoon:before-insert", (e, step_to_be_added) ->
      step_to_be_added.fadeIn "slow"

  $('.move-up-button').on 'click', moveIt("up", ".form-group")
    
  $('.move-down-button').on 'click', (e) ->
    e.preventDefault
    targetDiv = $(this).closest '.form-group'
    targetDiv.insertAfter targetDiv.nextAll('.form-group:first')
    return