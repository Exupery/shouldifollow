module ApplicationHelper
	def mins_from_now future_time
		(Time.at(future_time) - Time.now) / 60
	end

	def get_bg_trans percent, highest_percent
		(percent.to_f / highest_percent).to_f.round(1)
	end

	def get_timezones
		timezones = {
			"Universal Coordinated Time" => "Etc/UTC",
			"Atlantic/Azores" => "Atlantic/Azores",
			"America/Noronha" => "America/Noronha",
			"Argentina/Buenos Aires" => "America/Argentina/Buenos_Aires",
			"America/New York" => "America/New_York",
			"America/Chicago" => "America/Chicago",
			"America/Denver" => "America/Denver",
			"America/Los Angeles" => "America/Los_Angeles",
			"America/Anchorage" => "America/Anchorage",
			"America/Adak" => "America/Adak",
			"Pacific/Honolulu" => "Pacific/Honolulu",
			"Pacific/Pago Pago" => "Pacific/Pago_Pago",
			"Pacific/Auckland" => "Pacific/Auckland",
			"Pacific/Nauru" => "Pacific/Nauru",
			"Australia/Sydney" => "Australia/Sydney",
			"Pacific/Guam" => "Pacific/Guam",
			"Asia/Tokyo" => "Asia/Tokyo",
			"Asia/Shanghai" => "Asia/Shanghai",
			"Asia/Jakarta" => "Asia/Jakarta",
			"Asia/Dhaka" => "Asia/Dhaka",
			"Asia/Karachi" => "Asia/Karachi",
			"Europe/Moscow" => "Europe/Moscow",
			"Europe/Kaliningrad" => "Europe/Kaliningrad",
			"Europe/Helsinki" => "Europe/Helsinki",
			"Europe/Berlin" => "Europe/Berlin",
			"Europe/London" => "Europe/London"
		}
		tz_offsets = Hash.new
		timezones.each do |k, v|
			tz = Timezone::fetch v
			offset = tz.utc_offset != 0 ? tz.utc_offset / 60 / 60 : 0
			tz_offsets["#{k} UTC#{"+" if offset >= 0}#{offset.to_s}"] = offset
		end

		return tz_offsets
	end
end
