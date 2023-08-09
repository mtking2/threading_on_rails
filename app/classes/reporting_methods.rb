class ReportingMethods

	CHANNEL = 'reports_channel'

	class << self

		def threaded_report_example(params:)
			num_rows = params[:num_rows].to_f
			num_cols = params[:num_columns].to_f
			num_threads = params[:num_threads].to_f

			rows = []
			header_row = ['id']
			header_row.concat Array.new(num_cols) { |i| "row#{i + 1}" } # header row
			threads = []

			slice_length = (num_rows / num_threads).ceil

			semaphore = Mutex.new
			
			(1..num_rows).each_slice(slice_length).with_index do |slice, i|
				threads << Thread.new(i + 1, slice, params,) do |t_idx, t_slice, t_params|
					progress = 0

					t_slice.each_with_index do |row_num, row_idx|
						row = [row_num]
						row.concat Array.new(num_cols) { sleep rand(0..0.0001); rand }
						temp_progress = (((row_idx+1) / t_slice.length.to_f) * 100).floor # calculate progress as a whole number percentage
						sleep rand(0..0.0001) # simulate processing time
	
						semaphore.synchronize {
							rows << row
						}

						if temp_progress > progress || row_idx + 1 == t_slice.length
							progress = temp_progress
							send_thread_status_message(
								thread_id: t_idx,
								params: t_params,
								rows_generated: row_idx + 1,
								slice_length: t_slice.length,
								percent_complete: progress,
							)
						end
					end
				end
			end

			threads.each(&:join)
			rows.sort_by!(&:first)

			filename = "#{params[:report_name]}.csv"
			file = Tempfile.new(filename)
			begin
				CSV.open(file.path, 'wb') do |csv|
					csv << header_row
					rows.each do |row|
						csv << row
					end
				end

				file.rewind
				blob = ActiveStorage::Blob.create_after_upload!(io: file, filename: filename)
			ensure
				file.close
				file.unlink # deletes the temp file
			end

			Rails.application.routes.url_helpers.rails_blob_url(blob)
		end
		
		private

		def send_thread_status_message(thread_id:, params: {}, rows_generated: 0, slice_length: 0, percent_complete: 0)
			html = ActionController::Base.new.render_to_string(
				partial: 'reports/thread_progress_row',
				locals: {
					thread_id: thread_id,
					rows_generated: rows_generated,
					slice_length: slice_length,
					percent_complete: percent_complete,
				}
			)
			
			ActionCable.server.broadcast(ReportingMethods::CHANNEL, {
				action: 'report_processing',
				meta: params.merge(rows_generated: rows_generated, slice_length: slice_length, percent_complete: percent_complete),
				html: html,
				thread_id: thread_id,
			})
		end
	end
end
