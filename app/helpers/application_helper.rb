module ApplicationHelper

	def get_stats user
		stats = Hash.new(0.0)
		stats["tpd"] = 1
		stats["rpd"] = 2
		stats["ttlpd"] = stats["tpd"] + stats["rpd"]
		return stats
	end

	def toggle_expl
		logger.debug "not getting stats"
	end
end
