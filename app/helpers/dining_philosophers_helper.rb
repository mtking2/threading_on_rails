module DiningPhilosophersHelper

	CHANNEL = 'dining_philosophers_channel'

	def send_state_message(state)
		ActionCable.server.broadcast(CHANNEL, {
			action: state,
			thread_id: id,
			message: "#{name} is #{state}",
			type: self.class.name,
		})
	end

	def redis
		@redis ||= Redis.new
	end
end
