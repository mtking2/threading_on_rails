class PcController < ApplicationController
	include PcHelper

	def index
		redis.set(PcThread::CHANNEL_STATE_KEY, 'stopped')
	end

	def start
		redis.set(PcThread::CHANNEL_STATE_KEY, 'running')
		head :ok
	end

	def stop
		redis.set(PcThread::CHANNEL_STATE_KEY, 'stopped')
		head :ok
	end

	def add_producer
		color = random_pastel_color_in_hex
		# color = random_bright_color_in_hex

		thread = Producer.spawn(color: color)
		respond_to do |format|
			format.js {
				render json: {
					message: 'producer_created',
					html: render_to_string(partial: 'pc/producer', locals: { type: thread.class.name, id: thread.name, color: color }),
				}
			}
		end
	end

	def add_consumer
		Consumer.spawn
		head :ok
	end

	def render(*args)
		count_current_threads
		super(*args)
	end

	private

	def count_current_threads
		@num_current_threads = Thread.list.count { |t| t.kind_of?(PcThread) }
	end

	def redis
		@redis ||= Redis.new
	end

end
