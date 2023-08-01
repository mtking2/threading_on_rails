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
				$("#current-threads").html("#{data.count}")

			switch data.action
				
				when "item_produced"
					$("#resources").append( data.html )
					color_patch = $("[data-producer-id='#{data.thread_id}'] .color-patch")[0]
					color_patch.style.backgroundColor = "##{data.color}"
					# console.log(color_patch.style.backgroundColor)
					setTimeout (-> color_patch.style.backgroundColor = ''), 175
				
				when "item_consumed"
					item = $(".item[data-item-id='#{data.item.id}']")
					if item
						color_patch = $("[data-consumer-id='#{data.thread_id}'] .color-patch")[0]
						color_patch.style.backgroundColor = "##{data.color}"
						# console.log(color_patch.style.backgroundColor)
						$(item).find('i')[0].style.color = "##{data.color}"
						setTimeout (->
							color_patch.style.backgroundColor = ''
							$(item).remove()
						), 250
				
				when "producer_created"
					$("#producers").append( data.html )
				
				when "consumer_created"
					$("#consumers").append( data.html )
				
				when "producer_destroyed"
					$("[data-producer-id='#{data.thread_id}']").remove()
					if data.destroy_resources
						$(".item[data-thread-id='#{data.thread_id}']").remove()
				
				when "destroy_resources"
					setTimeout (->
						$('.item').remove()
					), 250
				
				when "consumer_destroyed"
					$("[data-consumer-id='#{data.thread_id}']").remove()
				
				when "status_changed"
					$("#channel-state").html(data.state)
				
				else
					break
