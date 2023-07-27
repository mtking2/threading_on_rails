class PcController < ApplicationController
	include PcHelper

	def index
		redis.set(PcThread::CHANNEL_STATE_KEY, CHANNEL_STATE_PAUSED) if channel_state.blank?
		@resources = redis.lrange(PcHelper::CHANNEL_QUEUE_KEY, 0, -1).map { |i| JSON.parse(i, object_class: OpenStruct) }
	end

	def start
		redis.set(PcThread::CHANNEL_STATE_KEY, CHANNEL_STATE_RUNNING)
		ActionCable.server.broadcast(CHANNEL, { action: 'status_changed', state: CHANNEL_STATE_RUNNING})
		head :ok
	end

	def pause
		redis.set(PcThread::CHANNEL_STATE_KEY, CHANNEL_STATE_PAUSED)
		ActionCable.server.broadcast(CHANNEL, { action: 'status_changed', state: CHANNEL_STATE_PAUSED})
		head :ok
	end

	def stop
		producer_threads.each do |thread|
			thread.destroy_resources = true
			thread.kill
		end
		consumer_threads.each do |thread|
			thread.destroy_resources = true
			thread.kill
		end
		redis.set(PcThread::CHANNEL_STATE_KEY, CHANNEL_STATE_PAUSED)
		redis.del(PcThread::CHANNEL_QUEUE_KEY)
		ActionCable.server.broadcast(CHANNEL, { action: 'status_changed', state: CHANNEL_STATE_PAUSED, count: current_thread_count})
		ActionCable.server.broadcast(CHANNEL, { action: 'destroy_resources' })
		head :ok
	end

	def kill_thread
		Thread.list.find { |t| t.respond_to?(:id) && t.id == params[:id] }&.kill
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
