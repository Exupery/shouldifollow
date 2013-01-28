require "open-uri"
require "json"
require "date"

class Twitterer
	@@user_url = "https://api.twitter.com/1/users/show.json?screen_name="
	@@tweet_url = "https://search.twitter.com/search.json?rpp=100&from="
	@@rate_limit_err = "Whoa! shouldifollow seems to have hit the Twitter API hourly rate limit."
	@@no_user_err = "Username not found"
	@@gen_err = "Whoops, something went wrong :-("

	def initialize uname
		@uname = uname
		@id = nil
		@error = nil
		@tpd = 0
		@rtpd = 0
		@allpd = 0
		@combpd = 0
		@tweet_ids = Array.new
		fetch_id_and_allpd
		fetch_t_rt_pd if @id
	end

	def fetch_id_and_allpd
		begin
			uri = open(@@user_url+@uname)
			json = JSON.parse(uri.read)	#REVERT
			#json = JSON.parse(open("http://127.0.0.1/zuser.json").read)
		rescue OpenURI::HTTPError => ex
			if ex.to_s.start_with?("404")
				@error = @@no_user_err 
			elsif ex.to_s.start_with?("420")
				@error = @@rate_limit_err 
			else
				@error = @@gen_err
			end
		end

		if json && json["errors"]
			@error = generate_error json
		elsif json
			@id = json["id_str"]
			@allpd = calc_allpd json["statuses_count"], json["created_at"]
		end
		puts @error
	end

	def fetch_t_rt_pd
		begin
			json = JSON.parse(open(@@tweet_url+@uname).read)	#REVERT
			#json = JSON.parse(open("http://127.0.0.1/tweets.json").read)
		rescue OpenURI::HTTPError => ex
			@error = (ex.to_s.start_with?("420")) ? @@rate_limit_err : generate_error(nil)
		end

		if !json || json["errors"]
			@error = generate_error json
		else
			parse_results json["results"] if json["results"] && json["results"].length > 0
		end
	end

	def parse_results tweets
		oldest = Date.today
		newest = Date.new(1970,1,1)
		tweet_cnt = 0;
		retweet_cnt = 0;

		tweets.each do |t|
			if t["created_at"]
				created = Date.parse(t["created_at"])
				newest = created if created > newest
				oldest = created if created < oldest
			end

			if t["text"]
				if t["text"].start_with?("RT")
					retweet_cnt += 1
				elsif t["to_user_id"] && t["to_user_id"].to_i == 0
					tweet_cnt += 1
				end
			end

			@tweet_ids.push(t["id_str"]) if t["id_str"]
		end

		days = (newest - oldest >= 1) ? newest - oldest : 1
		@tpd = (tweet_cnt / days).to_f.round(1)
		@rtpd = (retweet_cnt / days).to_f.round(1)
		@combpd = (@tpd + @rtpd).to_f.round(1)
		@tweet_ids.sort! {|a,b| b <=> a}
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
				@@rate_limit_err
			elsif err["message"] 
				err["message"] 
			end
		else
			@@gen_err
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

	def combined_per_day
		@combpd
	end

	def all_per_day
		@allpd
	end

	def is_user_not_found?
		return @error == @@no_user_err
	end

end