module PcHelper

	CHANNEL = 'pc_channel'
	CHANNEL_STATE_KEY = 'pc_channel_state'
	CHANNEL_QUEUE_KEY = 'pc_channel_queue'
	CHANNEL_STATE_RUNNING = 'running'
	CHANNEL_STATE_PAUSED = 'paused'
	CHANNEL_STATE_STOPPED = 'stopped'

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

	def producer_threads
		Thread.list.select { |t| t.class.name =~ /Producer/ }
	end

	def consumer_threads
		Thread.list.select { |t| t.class.name =~ /Consumer/ }
	end

	def producer_count
		producer_threads.length
	end

	def consumer_count
		consumer_threads.length
	end

	def current_thread_count
		producer_count + consumer_count
	end

	def redis
		@redis ||= Redis.new
	end


	def hsv_to_rgb(h, s, v)
		h_i = (h * 6).to_i
		f = h * 6 - h_i
		p = v * (1 - s)
		q = v * (1 - f * s)
		t = v * (1 - (1 - f) * s)
		r, g, b = v, t, p if h_i == 0
		r, g, b = q, v, p if h_i == 1
		r, g, b = p, v, t if h_i == 2
		r, g, b = p, q, v if h_i == 3
		r, g, b = t, p, v if h_i == 4
		r, g, b = v, p, q if h_i == 5
		[(r * 255).to_i, (g * 255).to_i, (b * 255).to_i]
	end
	
	def random_pastel_color_in_hsv
		h = rand # 0.0 to 1.0
		# s = rand(0.3..0.6)
		s = rand(0.2..0.8)
		v = rand(0.85..1.0)
		[h, s, v]
	end

	def random_pastel_color_in_hex
		hsv = random_pastel_color_in_hsv
		rgb = hsv_to_rgb(*hsv)
		rgb.map { |channel| channel.to_s(16).rjust(2, '0') }.join
	end

	def random_bright_color_in_hsv
		h = rand # 0.0 to 1.0
		s = rand # 0.0 to 1.0 for full range of saturation
		v = rand(0.75..1.0) # 0.5 to 1.0 for medium-bright to bright colors
		[h, s, v]
	end


	def random_bright_color_in_hex
		hsv = random_bright_color_in_hsv
		rgb = hsv_to_rgb(*hsv)
		rgb.map { |channel| channel.to_s(16).rjust(2, '0') }.join
	end
end
