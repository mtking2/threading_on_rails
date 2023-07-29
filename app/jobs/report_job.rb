class ReportJob < ApplicationJob
	queue_as :report

	def perform(report_name, params)
		ReportingMethods.send(report_name.to_sym, params: params)
	end
end
