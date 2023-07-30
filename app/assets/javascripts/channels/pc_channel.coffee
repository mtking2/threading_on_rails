App.channels.pc ||= {}

App.channels.pc.subscribe = ->
	App.channels.pc.subscription = App.cable.subscriptions.create "PcChannel",
		connected: ->
			# Called when the subscription is ready for use on the server
			console.log("PcChannel connected")

		disconnected: ->
			# Called when the subscription has been terminated by the server
			console.log("PcChannel disconnected")

		received: (data) ->
			# Called when there's incoming data on the websocket for this channel
			
			console.log(data.action, data)
			if data.count >= 0
				document.querySelector("#current-threads").innerHTML = "Current Threads: #{data.count}"

			switch data.action
				
				when "item_produced"
					document.querySelector("#resources").insertAdjacentHTML( 'beforeend', data.html )
					color_patch = document.querySelector("[data-producer-id='#{data.thread_id}'] .color-patch")
					color_patch.style.backgroundColor = "##{data.color}"
					# console.log(color_patch.style.backgroundColor)
					setTimeout (-> color_patch.style.backgroundColor = ''), 175
				
				when "item_consumed"
					item = document.querySelector(".item[data-item-id='#{data.item.id}']")
					if item
						color_patch = document.querySelector("[data-consumer-id='#{data.thread_id}'] .color-patch")
						color_patch.style.backgroundColor = "##{data.color}"
						# console.log(color_patch.style.backgroundColor)
						item.querySelector('i').style.color = "##{data.color}"
						setTimeout (-> 
							color_patch.style.backgroundColor = ''
							item.remove()
						), 250
				
				when "producer_created"
					document.querySelector("#producers").insertAdjacentHTML( 'beforeend', data.html )
				
				when "consumer_created"
					document.querySelector("#consumers").insertAdjacentHTML( 'beforeend', data.html )
				
				when "producer_destroyed"
					document.querySelector("[data-producer-id='#{data.thread_id}']").remove()
					if data.destroy_resources
						document.querySelectorAll(".item[data-thread-id='#{data.thread_id}']").forEach((item) => item.remove())
				
				when "destroy_resources"
					setTimeout (->
						document.querySelectorAll('.item').forEach (item) -> item.remove()
					), 250
				
				when "consumer_destroyed"
					document.querySelector("[data-consumer-id='#{data.thread_id}']").remove()
				
				when "status_changed"
					document.querySelector("#channel-state").innerHTML = data.state
				
				else
					break
