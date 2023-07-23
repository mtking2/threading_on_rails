module PcHelper
	def hsv_to_rgb(h, s, v)
		h_i = (h * 6).to_i
		f = h * 6 - h_i
		p = v * (1 - s)
		q = v * (1 - f * s)
		t = v * (1 - (1 - f) * s)
		r, g, b = v, t, p if h_i == 0
		r, g, b = q, v, p if h_i == 1
		r, g, b = p, v, t if h_i == 2
		r, g, b = p, q, v if h_i == 3
		r, g, b = t, p, v if h_i == 4
		r, g, b = v, p, q if h_i == 5
		[(r * 255).to_i, (g * 255).to_i, (b * 255).to_i]
	end
	
	def random_pastel_color_in_hsv
		h = rand # 0.0 to 1.0
		# s = rand(0.3..0.6)
		s = rand(0.2..0.8)
		v = rand(0.85..1.0)
		[h, s, v]
	end

	def random_pastel_color_in_hex
		hsv = random_pastel_color_in_hsv
		rgb = hsv_to_rgb(*hsv)
		rgb.map { |channel| channel.to_s(16).rjust(2, '0') }.join
	end

	def random_bright_color_in_hsv
		h = rand # 0.0 to 1.0
		s = rand # 0.0 to 1.0 for full range of saturation
		v = rand(0.75..1.0) # 0.5 to 1.0 for medium-bright to bright colors
		[h, s, v]
	end


	def random_bright_color_in_hex
		hsv = random_bright_color_in_hsv
		rgb = hsv_to_rgb(*hsv)
		rgb.map { |channel| channel.to_s(16).rjust(2, '0') }.join
	end
end
