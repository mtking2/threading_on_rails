class PcThread < Thread

	CHANNEL = 'pc_channel'
	CHANNEL_STATE_KEY = 'pc_channel_state'

	class << self
		def spawn(color: 'ffffff')
			id = SecureRandom.uuid
			display_name = "#{self.name}:#{id}"
			# html = ApplicationController.renderer.render(partial: 'dashboard/item', locals: { color: "#F33" })

			html = ApplicationController.renderer.render(
				partial: 'pc/item',
				locals: { color: color }
			)

			t = self.new do
				while redis.get(CHANNEL_STATE_KEY) == 'running' do
					ActionCable.server.broadcast(CHANNEL, {
						message: display_name,
						id: id,
						type: self.name,
						count: count_current_threads,
						html: html,
					})

					sleep rand(0.2..2)
				end
			end
			t.name = id

			t
		end

		private

		def count_current_threads
			Thread.list.count { |t| t.class.superclass.name =~ /#{self.superclass.name}/ }
		end

		def redis
			@redis ||= Redis.new
		end
	end


end
