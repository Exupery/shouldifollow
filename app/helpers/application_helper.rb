module ApplicationHelper

	def mins_from_now future_time
		return (Time.at(future_time) - Time.now) / 60
	end

	def get_bg_trans percent, highest_percent
		return (percent.to_f / highest_percent).to_f.round(1)
	end

	def get_timezones
		timezones = {
			"Universal Coordinated Time (UTC)"=>0,
			"Central African Time (UTC-1)"=>-1, 
			"Brazil Eastern Time (UTC-2)"=>-2, 
			"Argentina Standard Time (UTC-3)"=>-3,
			"Canada Newfoundland Time (UTC-4)"=>-4,
			"Eastern Standard Time (UTC-5)"=>-5,
			"Central Standard Time (UTC-6)"=>-6,
			"Mountain Standard Time (UTC-7)"=>-7,
			"Pacific Standard Time (UTC-8)"=>-8,
			"Alaska Standard Time (UTC-9)"=>-9,
			"Hawaii Standard Time (UTC-10)"=>-10,
			"Midway Islands Time (UTC-11)"=>-11,
			"New Zealand Standard Time (UTC+12)"=>+12,
			"Solomon Standard Time (UTC+11)"=>+11,
			"Australia Eastern Time (UTC+10)"=>+10,
			"Japan Standard Time (UTC+9)"=>+9,
			"China Taiwan Time (UTC+8)"=>+8,
			"Vietnam Standard Time (UTC+7)"=>+7,
			"Bangladesh Standard Time (UTC+6)"=>+6,
			"Pakistan Lahore Time (UTC+5)"=>+5,
			"Near East Time (UTC+4)"=>+4,
			"Eastern African Time (UTC+3)"=>+3,
			"Eastern European Time (UTC+2)"=>+2,
			"European Central Time (UTC+1)"=>+1
		}
		select("timezones", "offsets", timezones)
	end

end
