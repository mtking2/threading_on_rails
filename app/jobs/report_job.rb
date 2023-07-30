class ReportJob < ApplicationJob
	queue_as :report

	def perform(report_name, params)
		url = nil
		benchmark = Benchmark.measure do
			url = ReportingMethods.send(report_name.to_sym, params: params)
		end
		ActionCable.server.broadcast(ReportingMethods::CHANNEL, {
			action: 'report_generated',
			html: report_row_html(
				params.merge(
					benchmark: benchmark.real.round(4),
					timestamp: DateTime.now.to_s,
					url: url
				)
			),
			meta: params,
			url: url,
		})
	end

	private

	def report_row_html(params)
		ApplicationController.renderer.render(
			partial: 'reports/row',
			locals: params
		)
	end
end
