module DiningPhilosophersHelper

	CHANNEL = 'dining_philosophers_channel'
	CHANNEL_STATE_KEY = 'dp_channel_state'
	CHANNEL_STATE_RUNNING = 'running'
	CHANNEL_STATE_PAUSED = 'paused'
	CHANNEL_STATE_STOPPED = 'stopped'

	$g_lock = Mutex.new

	def channel_state
		redis.get(CHANNEL_STATE_KEY)
	end

	def channel_paused?
		channel_state == CHANNEL_STATE_PAUSED
	end

	def channel_running?
		channel_state == CHANNEL_STATE_RUNNING
	end

	def channel_stopped?
		channel_state == CHANNEL_STATE_STOPPED
	end

	def start_philosophers
		redis.set(CHANNEL_STATE_KEY, CHANNEL_STATE_RUNNING)
		ActionCable.server.broadcast(CHANNEL, { action: 'status_changed', state: CHANNEL_STATE_RUNNING})
	end

	def stop_philosophers
		redis.set(CHANNEL_STATE_KEY, CHANNEL_STATE_STOPPED)
		ActionCable.server.broadcast(CHANNEL, { action: 'status_changed', state: CHANNEL_STATE_STOPPED})
		# philosopher_threads.each(&:kill)
	end

	def pause_philosophers
		redis.set(CHANNEL_STATE_KEY, CHANNEL_STATE_PAUSED)
		ActionCable.server.broadcast(CHANNEL, { action: 'status_changed', state: CHANNEL_STATE_PAUSED})
	end

	def philosopher_threads
		Thread.list.select { |t| t.class.name =~ /Philosopher/ }
	end

	def send_chopstick_message(chopstick, philosopher, action)
		$g_lock.synchronize {
			sleep 0.1
			ActionCable.server.broadcast(CHANNEL, {
				action: action,
				chopstick_id: chopstick.id,
				thread_id: philosopher.id
			})
		}
	end

	def send_state_message(state)
		$g_lock.synchronize {
			sleep 0.1
			ActionCable.server.broadcast(CHANNEL, {
				action: state,
				thread_id: id,
				message: "#{name} #{state}",
				type: self.class.name,
				chopsticks: [left_chopstick.id, right_chopstick.id]
			})
		}
	end

	def redis
		@redis ||= Redis.new
	end
end
