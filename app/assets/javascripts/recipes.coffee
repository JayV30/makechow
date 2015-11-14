# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
  
  $.fn.moveIt = undefined
  setOrder = undefined


  # moveIt function for moving elements on the recipe page
  # direction: "up" or "down" (required)
  # target: the targeted parent div of the element the function is called on. This is the div that will move.
  $.fn.moveIt = (direction, target) ->
    targetDiv = undefined
    targetDiv = $(this).closest(target)
    if direction == 'up'
      targetDiv.insertBefore targetDiv.prevAll(target.concat(':first'))
    else if direction == 'down'
      targetDiv.insertAfter targetDiv.nextAll(target.concat(':first'))
    return
    
  # setOrder function will set the hidden field :step_number to the correct order as displayed on page
  setOrder = ->
    stepsArr = $('#steps > .form-group').not('.form-group[style="display: none;"]')
    count = stepsArr.length
    i = 0
    while i < count
      input = $(stepsArr[i]).find('input[data-field="step_number"]')
      input.val(i)
      i++
    return
    

  $('#recipe_image_url').bind "change", ->
    size_in_megabytes = this.files[0].size/1024/1024
    if size_in_megabytes > 5 then alert('Maximum file size is 5MB. Please choose a smaller file.')

  $('#steps')
    .on "cocoon:before-remove", (e, step) ->
      $(this).data 'remove-timeout', 1000
      step.fadeOut "slow"
    .on "cocoon:after-remove", ->
      setOrder()
    .on "cocoon:before-insert", (e, step_to_be_added) ->
      step_to_be_added.fadeIn "slow"
    .on "cocoon:after-insert", ->
      setOrder()

  $('.move-up-button').on 'click', (e) ->
    e.preventDefault  
    $(this).moveIt("up", ".form-group")
    setOrder()
    
  $('.move-down-button').on 'click', (e) ->
    e.preventDefault
    $(this).moveIt("down", ".form-group")
    setOrder()