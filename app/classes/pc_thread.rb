class PcThread < Thread
	include PcHelper
	
	IDLE = 'idle'
	RUNNING = 'running'
	PRODUCED = 'produced'
	CONSUMED = 'consumed'

	attr_accessor :id, :state, :color, :destroy_resources

	class << self
		include PcHelper

		def spawn
			id = SecureRandom.uuid
			color = random_pastel_color_in_hex
			thread = self.new(id: id, state: IDLE, color: color)
			thread.name = id
			thread
		end

	end

	def action
		raise NotImplementedError
	end

	def initialize(*args, **kwargs)
		kwargs.each { |attribute, value| self.__send__ "#{attribute}=", value }
		super { run }
		send_init_message
	end

	def run
		while channel_state.in?([CHANNEL_STATE_RUNNING, CHANNEL_STATE_PAUSED]) do
			if channel_paused?
				state = IDLE
				sleep 1 while channel_paused?
			elsif channel_running? && state != RUNNING
				state = RUNNING
			end

			next if channel_stopped?
			
			process_item(action)
			sleep rand(0.2..2)
		end
	end

	def kill
		super
		send_kill_message
	end

	private

	def process_item(action)
		processed_item = case action
			when PRODUCED
				item_id = SecureRandom.uuid
				item_data = {
					id: item_id,
					thread_id: id,
					color: color,
				}
				redis.rpush(PcHelper::CHANNEL_QUEUE_KEY, item_data.to_json)
				item_data
			when CONSUMED
				JSON.parse(redis.lpop(PcHelper::CHANNEL_QUEUE_KEY) || '{}')
		end
		send_item_message(action, processed_item)
	end

	def send_init_message
		ActionCable.server.broadcast(CHANNEL, {
			action: "#{self.class.name.downcase}_created",
			count: current_thread_count,
			html: thread_html,
			thread_id: id,
			message: display_name,
			type: self.class.name,
		})
	end

	def send_item_message(action, item)
		data = {
			action: "item_#{action}",
			color: color,
			count: current_thread_count,
			item: item,
			thread_id: id,
			message: display_name,
			type: self.class.name,
		}
		data.merge!(html: item_html(item)) if action == PRODUCED

		ActionCable.server.broadcast(CHANNEL, data)
	end

	def send_kill_message
		sleep 0.1
		ActionCable.server.broadcast(CHANNEL, {
			action: "#{self.class.name.downcase}_destroyed",
			count: current_thread_count,
			thread_id: id,
			message: display_name,
			type: self.class.name,
			destroy_resources: destroy_resources,
		})
	end

	def display_name
		"#{self.class.name}:#{id}"
	end

	def item_html(item)
		ApplicationController.renderer.render(
			partial: 'pc/item',
			locals: { id: item[:id], thread_id: id, color: color }
		)
	end

	def thread_html
		ApplicationController.renderer.render(
			partial: "pc/#{self.class.name.downcase}",
			locals: {
				type: self.class.name,
				id: id,
				color: color,
			}
		)
	end

end
