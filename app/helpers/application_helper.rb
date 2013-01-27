module ApplicationHelper

	def get_stats uname
		tw = Twitterer.new(uname)
		logger.debug tw.error
		stats = Hash.new(0.0)
		stats["error"] = tw.error
		stats["tpd"] = 1.4
		stats["rtpd"] = 8
		stats["trtpd"] = stats["tpd"] + stats["rtpd"]
		stats["totalpd"] = 20
		return tw
	end

	def get_user
		url = "https://api.twitter.com/1/users/lookup.json?screen_name=frostmatthew&include_entities=true"
	end
end
