class Array

	def sum
		inject nil do |sum, x|
			sum ? sum + x : x
		end
	end

end