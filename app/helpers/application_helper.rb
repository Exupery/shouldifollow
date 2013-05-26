module ApplicationHelper

	def mins_from_now future_time
		return (Time.at(future_time) - Time.now) / 60
	end

end
