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
			
			# console.log(data)

			switch data.action
				when "report_generated"
					console.log(data)

					setTimeout (->
						$("##{data.meta.report_uuid}").replaceWith(data.html)
					), 1000
					
					if $("#report-table").is(":hidden")
						$("#report-table").show()

				when "report_processing"
					thread_progress = $("##{data.meta.report_uuid} [data-thread-id='#{data.thread_id}']")

					if not thread_progress.length
						$("##{data.meta.report_uuid} td").append(data.html)
					else
						# thread_progress.replaceWith(data.html)
						thread_progress.find(".progress").attr("aria-valuenow", data.meta.percent_complete)
						thread_progress.find(".progress-bar").css("width", "#{data.meta.percent_complete}%")
						thread_progress.find(".label").text("T#{data.thread_id} - #{data.meta.rows_generated}/#{data.meta.slice_length} - #{data.meta.percent_complete}%")
				else
					break
