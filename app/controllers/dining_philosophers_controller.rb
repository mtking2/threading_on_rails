class DiningPhilosophersController < ApplicationController
	def index
		@chopsticks = Array.new(5) { |e| e = Chopstick.new }
		@philosophers = []

		names = %w[Aristotle Confucius Descartes Kant Plato]

		names.each_with_index do |ph, i|
			phil = Philosopher.new(
				name: ph,
				left_chopstick: @chopsticks[i],
				right_chopstick: @chopsticks[(i + 1) % names.size]
			)
			@philosophers.push phil
		end
	end
end
