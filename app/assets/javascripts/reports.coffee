# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
	if $("[data-channel='reports']").length > 0
		App.channels.reports.subscribe()
	else
		unless App.channels.reports.subscription is undefined
			App.channels.reports.subscription.unsubscribe()
			delete App.channels.reports.subscription
