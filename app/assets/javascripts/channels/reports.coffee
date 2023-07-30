App.channels.reports ||= {}

App.channels.reports.subscribe = ->
	App.channels.reports.subscription = App.cable.subscriptions.create "ReportsChannel",
		connected: ->
			# Called when the subscription is ready for use on the server
			console.log("ReportsChannel connected")

		disconnected: ->
			# Called when the subscription has been terminated by the server
			console.log("ReportsChannel disconnected")

		received: (data) ->
			# Called when there's incoming data on the websocket for this channel
			console.log(data)

			switch data.action
				when "report_generated"
					$("#report-rows").prepend(data.html)
					if $("#report-table").is(":hidden")
						$("#report-table").show()
				else
					break
