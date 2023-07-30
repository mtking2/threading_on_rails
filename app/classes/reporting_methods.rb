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
			
			(1..num_rows).each_slice(slice_length).with_index do |slice, i|
				threads << Thread.new(i + 1, slice) do |t_idx, t_slice|
					t_slice.each do |row_num|
						row = [row_num]
						row.concat Array.new(num_cols) { sleep rand(0..0.0001); rand }
						sleep rand(0..0.0001) # simulate processing time
						rows << row
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

	end
end
