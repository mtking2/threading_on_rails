class Philosopher < Thread
	include DiningPhilosophersHelper

	attr_accessor :id, :name, :left_chopstick, :right_chopstick, :finished

	def initialize(args = {})
		@id = SecureRandom.uuid
		args.each_pair { |attribute, value| self.__send__ "#{attribute}=", value }
		@finished = false
		super { start }
	end

	def eat
		left_chopstick.synchronize {
			send_chopstick_message(left_chopstick, self, 'picked_up')
			right_chopstick.synchronize {
				send_chopstick_message(right_chopstick, self, 'picked_up')
				emote 'is eating'
				ponder
			}
			send_chopstick_message(right_chopstick, self, 'put_down')
		}
		send_chopstick_message(left_chopstick, self, 'put_down')
	end

	def think
		emote 'is thinking'
		ponder
	end

	def ponder min=4, max=8
		return if @finished
		sleep rand min..max
		sleep 1 while channel_paused?
	end

	def emote str
		send_state_message str
	end

	def start
		sleep 1
		while !@finished
			stop if channel_stopped?
			think
			break if @finished
			eat
		end
		emote 'is finished'
	end

	def stop
		@finished = true
	end

end
