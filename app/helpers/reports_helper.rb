module ReportsHelper

	def all_reports
		ReportingMethods.methods(false)
	end

	def csv_for(report_name, params:)
		raise "Report not found" if !ReportingMethods.respond_to?(report_name, true)

		ReportingMethods.send(report_name.to_sym, params: params)
	end

end
