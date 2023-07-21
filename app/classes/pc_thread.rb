class PcThread < Thread

	CHANNEL = 'pc_channel'
	CHANNEL_STATE_KEY = 'pc_channel_state'

	class << self
		def spawn
			id = SecureRandom.uuid
			t = self.new do
				while redis.get(CHANNEL_STATE_KEY) == 'running' do
					ActionCable.server.broadcast CHANNEL, message: "#{self.name}:#{id}", data: { id: id, count: count_current_threads }
					sleep 1
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
