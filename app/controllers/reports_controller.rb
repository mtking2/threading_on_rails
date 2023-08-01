class ReportsController < ApplicationController
	include ReportsHelper

	def index
		@reports = all_reports
		@past_reports_count = past_reports.count
	end

	def csv_report
		raise "Report not found" if !ReportingMethods.respond_to?(report_params[:report_name], true)

		ReportJob.perform_later(report_params[:report_name], report_params)
		head :ok
	end

	def purge_past_reports
		past_reports.each(&:purge)
		redirect_back fallback_location: root_path
	end

	private

	def report_params
		params.permit(:report_name, :num_rows, :num_columns, :num_threads, :report_uuid)
	end

	def past_reports
		ActiveStorage::Blob.where(filename: all_reports.map{|r| "#{r.to_s}.csv"})
	end
end
