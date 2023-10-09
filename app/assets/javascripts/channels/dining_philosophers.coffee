App.channels.dining_philosophers ||= {}

App.channels.dining_philosophers.subscribe = ->
  App.channels.dining_philosophers.subscription = App.cable.subscriptions.create "DiningPhilosophersChannel",
    connected: ->
      # Called when the subscription is ready for use on the server
      console.log("DiningPhilosophersChannel connected")

    disconnected: ->
      # Called when the subscription has been terminated by the server
      console.log("DiningPhilosophersChannel disconnected")

    received: (data) ->
      # Called when there's incoming data on the websocket for this channel

      console.log(data)
      philosopher = $("##{data.thread_id}")

      switch data.action
        when "is thinking"
          philosopher.find('.emoji').text("🤔")
        when "is eating"
          philosopher.find('.emoji').text("😯")
        when "is finished"
          philosopher.find('.emoji').text("😐")
        when "picked_up"
          $("##{data.chopstick_id}").attr('display', 'none')
          philosopher.find(".chopsticks > .#{data.chopstick_id}").attr('display', '')
        when "put_down"
          $("##{data.chopstick_id}").attr('display', '')
          philosopher.find(".chopsticks > .#{data.chopstick_id}").attr('display', 'none')
        else
          break
