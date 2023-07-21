App.pc = App.cable.subscriptions.create "PcChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    console.log("PcChannel connected")

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log(data, data.type)
    switch data.type
      when "Producer"
        console.log("Producer")
        document.querySelector("#things").insertAdjacentHTML( 'beforeend', "<span class='item'>[]</span>" )
      when "Consumer"
        console.log("Consumer")
        item = document.querySelector(".item")
        if item
          item.remove()
      else
      	break
