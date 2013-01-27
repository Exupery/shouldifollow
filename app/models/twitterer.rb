class Twitterer

	def initialize uname
		@uname = uname
		@tpd = 0
		@rtpd = 0
		@allpd = 0
	end

	def uname
		@uname
	end

	def error
		#@error = "Whoa! shouldifollow seems to have hit the Twitter API hourly rate limit."
		@error
	end

	def tweets_per_day
		@tpd
	end

	def retweets_per_day
		@rtpd
	end

	def all_per_day
		@allpd
	end

end