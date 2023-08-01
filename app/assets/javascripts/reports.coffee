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

	$("input[type='submit']").on "click", (e) ->
		e.preventDefault()

		if $("#report-table").is(":hidden")
			$("#report-table").show()

		uuid = crypto.randomUUID()
		$("#report-rows").prepend("
			<tr id='#{uuid}'>
				<td class='text-center' colspan='100%'>
				</td>
			</tr>
		".trim())

		$("input[name='report_uuid']").val(uuid)
		Rails.fire($("form")[0], "submit")
