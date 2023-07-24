class PcThread < Thread
	include PcHelper
	
	IDLE = 'idle'
	RUNNING = 'running'

	attr_accessor :id, :state, :color

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
			
			send_item_message(action)
			sleep rand(0.2..2)
		end
	end

	

	private

	def send_init_message
		ActionCable.server.broadcast(CHANNEL, {
			action: "#{self.class.name.downcase}_created",
			count: current_thread_count,
			html: thread_html,
			id: id,
			message: display_name,
			type: self.class.name,
		})
	end

	def send_item_message(action)
		ActionCable.server.broadcast(CHANNEL, {
			action: "item_#{action}",
			count: current_thread_count,
			html: item_html,
			id: id,
			message: display_name,
			type: self.class.name,
		})
	end

	def display_name
		"#{self.class.name}:#{id}"
	end

	def item_html
		@item_html ||= ApplicationController.renderer.render(
			partial: 'pc/item',
			locals: { color: color }
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
