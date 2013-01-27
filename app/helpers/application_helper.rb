module ApplicationHelper

	def get_stats user
		stats = Hash.new(0.0)
		stats["error"] = nil
		stats["tpd"] = 1.4
		stats["rtpd"] = 8
		stats["trtpd"] = stats["tpd"] + stats["rtpd"]
		stats["totalpd"] = 20
		stats["error"] = "Whoa! shouldifollow seems to have hit the Twitter API hourly rate limit."
		return stats
	end

	def toggle_expl
		logger.debug "not getting stats"
	end
end
