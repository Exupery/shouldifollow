require 'net/http'
require 'open-uri'
require 'json'

class Twitterer
	@@user_url = "https://api.twitter.com/1/users/show.json?screen_name="

	def initialize uname
		@uname = uname
		@id = 0
		@tpd = 0
		@rtpd = 0
		@allpd = 0
		update_stats
	end

	def update_stats
		json = JSON.parse(open(@@user_url+@uname).read)
		puts json 	#DELME
		puts "*************"	#DELME
		@id = json["id_str"]
		puts json["id_str"]		#DELME
		puts json["created_at"]	#DELME
		@allpd = calc_allpd json["statuses_count"], json["created_at"]
	end

	def calc_allpd count, since
		puts count
		puts since
		18
	end

	def error
		#@error = "Whoa! shouldifollow seems to have hit the Twitter API hourly rate limit."
		@error
	end

	def uname
		@uname
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