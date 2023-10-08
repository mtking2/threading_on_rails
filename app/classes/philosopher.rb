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
			right_chopstick.synchronize {
				emote 'is eating'
				ponder
			}
		}
	end

	def think
		emote 'is thinking'
		ponder
	end

	def ponder min=4, max=8
		return if @finished
		sleep rand min..max
	end

	def emote str
		send_state_message str
	end

	def start
		sleep 1
		while !@finished
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
