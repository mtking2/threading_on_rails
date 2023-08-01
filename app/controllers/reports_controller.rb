class ReportsController < ApplicationController
	include ReportsHelper

	def index
		@reports = all_reports
	end

	def csv_report
		raise "Report not found" if !ReportingMethods.respond_to?(report_params[:report_name], true)

		ReportJob.perform_later(report_params[:report_name], report_params)
		head :ok
	end

	private

	def report_params
		params.permit(:report_name, :num_rows, :num_columns, :num_threads, :report_uuid)
	end
end
