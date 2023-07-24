App.pc = App.cable.subscriptions.create "PcChannel",
	connected: ->
		# Called when the subscription is ready for use on the server
		console.log("PcChannel connected")

	disconnected: ->
		# Called when the subscription has been terminated by the server

	received: (data) ->
		# Called when there's incoming data on the websocket for this channel
		console.log(data.action, data)
		switch data.action
			when "item_produced"
				# console.log("Producer")
				# item = "<div class='item p-1'><i class='fa-solid fa-cube fa-xl'></i></div>"
				document.querySelector("#resources").insertAdjacentHTML( 'beforeend', data.html )
			when "item_consumed"
				# console.log("Consumer")
				item = document.querySelector(".item")
				if item
					item.remove()
			when "producer_created"
				document.querySelector("#producers").insertAdjacentHTML( 'beforeend', data.html )
			when "consumer_created"
				document.querySelector("#consumers").insertAdjacentHTML( 'beforeend', data.html )
			else
				break
