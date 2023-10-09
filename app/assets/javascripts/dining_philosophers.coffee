# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  if $("[data-channel='dining_philosophers']").length > 0
    App.channels.dining_philosophers.subscribe()
  else
    unless App.channels.dining_philosophers.subscription is undefined
      App.channels.dining_philosophers.subscription.unsubscribe()
      delete App.channels.dining_philosophers.subscription