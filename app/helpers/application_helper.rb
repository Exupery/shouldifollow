module ApplicationHelper

	def get_stats uname
		 
		logger.debug(uname)
		tw = Twitterer.new(uname)
		return tw
	end

	def get_user
		url = "https://api.twitter.com/1/users/lookup.json?screen_name=frostmatthew&include_entities=true"
	end
end
