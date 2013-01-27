module ApplicationHelper

	def get_stats uname
		tw = Twitterer.new(uname)
		logger.debug tw.uname
		stats = Hash.new(0.0)
		stats["error"] = nil
		stats["tpd"] = 1.4
		stats["rtpd"] = 8
		stats["trtpd"] = stats["tpd"] + stats["rtpd"]
		stats["totalpd"] = 20
		#stats["error"] = "Whoa! shouldifollow seems to have hit the Twitter API hourly rate limit."
		return stats
	end

	def get_user
		url = "https://api.twitter.com/1/users/lookup.json?screen_name=frostmatthew&include_entities=true"
	end
end
