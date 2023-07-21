App.pc = App.cable.subscriptions.create "PcChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    console.log("PcChannel connected")

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log(data)
