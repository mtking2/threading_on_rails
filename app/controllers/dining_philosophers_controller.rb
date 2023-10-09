class DiningPhilosophersController < ApplicationController
	include DiningPhilosophersHelper

	def index
		philosopher_threads.each(&:kill)
		redis.set(CHANNEL_STATE_KEY, CHANNEL_STATE_PAUSED)

		@chopsticks = Array.new(5) { |_| Chopstick.new }
		@philosophers = []

		@philosophers.push Philosopher.new(name: 'Aristotle', 	right_chopstick: @chopsticks[0], left_chopstick: @chopsticks[1])
		@philosophers.push Philosopher.new(name: 'Confucius', 	right_chopstick: @chopsticks[1], left_chopstick: @chopsticks[2])
		@philosophers.push Philosopher.new(name: 'Descartes', 	right_chopstick: @chopsticks[2], left_chopstick: @chopsticks[3])
		@philosophers.push Philosopher.new(name: 'Kant', 		right_chopstick: @chopsticks[3], left_chopstick: @chopsticks[4])
		@philosophers.push Philosopher.new(name: 'Plato', 		right_chopstick: @chopsticks[0], left_chopstick: @chopsticks[4]) # left-handed

		@philosophers.each do |phil|
			puts "#{phil.name} L#{phil.left_chopstick.id} R#{phil.right_chopstick.id}"
		end
	end

	def start
		start_philosophers
		head :ok
	end

	def stop
		stop_philosophers
		head :ok
	end

	def pause
		pause_philosophers
		head :ok
	end

end
