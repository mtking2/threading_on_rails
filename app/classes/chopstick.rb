class Chopstick < Mutex
	attr_reader :id

	def initialize
		@id = SecureRandom.uuid
	end
end
