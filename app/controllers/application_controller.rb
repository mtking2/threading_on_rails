class ApplicationController < ActionController::Base
	before_action :load_demos
	def load_demos
		@demos = [
			{title: "Dining Philosophers", path: "/dining_philosophers"},
			{title: "Economy Simulator", path: "/pc"},
			{title: "Report Generator", path: "/reports"},
		].map{|d| Hashie::Mash.new(d)}.sort_by { |d| d[:title] }
	end
end
