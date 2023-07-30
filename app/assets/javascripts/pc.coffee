# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
	if $("[data-channel='pc']").length > 0
		App.channels.pc.subscribe()
	else
		unless App.channels.pc.subscription is undefined
			App.channels.pc.subscription.unsubscribe()
			delete App.channels.pc.subscription
