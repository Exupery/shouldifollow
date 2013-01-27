require "open-uri"
require "json"
require "date"

class Twitterer
	@@user_url = "https://api.twitter.com/1/users/show.json?screen_name="

	def initialize uname
		@uname = uname
		@id = nil
		@tpd = 0
		@rtpd = 0
		@allpd = 0
		fetch_id_and_allpd
		fetch_t_rt_pd if @id
	end

	def fetch_t_rt_pd
		begin
			json = JSON.parse(open("http://127.0.0.1/tweets.json").read)
		rescue
			@error = generate_error nil
		end
	end

	def fetch_id_and_allpd
		begin
			#json = JSON.parse(open(@@user_url+@uname).read)	#REVERT
			json = JSON.parse(open("http://127.0.0.1/user.json").read)
			#json = JSON.parse(open("https://api.twitter.com/1/users/show.json?screen_name=frostmatthew").read)
		rescue
			@error = generate_error nil
		end

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
		if errors && errors["errors"] && errors["errors"][0]
			err = errors["errors"][0]
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