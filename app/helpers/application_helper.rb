module ApplicationHelper

	def mins_from_now future_time
		return (Time.at(future_time) - Time.now) / 60
	end

	def get_bg_trans percent, highest_percent
		return (percent.to_f / highest_percent).to_f.round(1)
	end

end
