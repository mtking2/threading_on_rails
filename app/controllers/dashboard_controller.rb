class DashboardController < ApplicationController

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
		Producer.spawn
		head :ok
	end

	def add_consumer
		Consumer.spawn
		head :ok
	end

	def render
		count_current_threads
		super
	end

	private

	def count_current_threads
		@num_current_threads = Thread.list.count { |t| t.kind_of?(PcThread) }
	end

	def redis
		@redis ||= Redis.new
	end
end
