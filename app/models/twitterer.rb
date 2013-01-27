require "open-uri"
require "json"
require "date"

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
		#json = JSON.parse(open(@@user_url+@uname).read)	#REVERT
		#json = JSON.parse(open("http://127.0.0.1/user.json").read)
		#json = JSON.parse(open("https://api.twitter.com/1/users/show.json?screen_name=zzzfrostmatthew").read)
		json = JSON.parse(open("http://127.0.0.1/error.json").read)
		if !json || json["errors"]
			@error = generate_error json
		else
			@id = json["id_str"]
			@allpd = calc_allpd json["statuses_count"], json["created_at"]
		end
	end

	def calc_allpd count, since
		count = 0 if !count
		days = (since) ? Date.today-Date.parse(since) : 1;
		return (count / days).to_f.round(1)
	end

	def generate_error errors
		err = errors["errors"][0] if errors["errors"][0]
		if err
			code = err["code"] if err["code"]
			if code && (code==88 || code==420)
				"Whoa! shouldifollow seems to have hit the Twitter API hourly rate limit."
			elsif err["message"] 
				err["message"] 
			end
		else
			"Whoops, something went wrong :-("
		end
	end

	def error
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