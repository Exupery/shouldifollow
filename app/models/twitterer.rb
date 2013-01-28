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
		@latest_tweet_id = nil
		fetch_id_and_allpd
		fetch_t_rt_pd if @id
	end

	def fetch_id_and_allpd
		begin
			#json = JSON.parse(open(@@user_url+@uname).read)	#REVERT
			json = JSON.parse(open("http://127.0.0.1/user.json").read)
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
			#json = JSON.parse(open(@@tweet_url+@uname).read)	#REVERT
			json = JSON.parse(open("http://127.0.0.1/tweets.json").read)
		rescue OpenURI::HTTPError => ex
			@error = (ex.to_s.start_with?("420")) ? @@rate_limit_err : @@gen_err
		end

		if json && json["errors"]
			@error = generate_error json
		elsif json
			parse_results json["results"] if json["results"] && json["results"].length > 0
		end
	end

	def parse_results tweets
		oldest = Date.today
		newest = Date.new(1970,1,1)
		tweet_cnt = 0;
		retweet_cnt = 0;

		tweets.each do |t|
			if t["created_at"] && t["text"]
				created = Date.parse(t["created_at"])
				newest = created if created > newest
				oldest = created if created < oldest

				if t["text"].start_with?("RT")
					retweet_cnt += 1
				elsif t["to_user_id"] && t["to_user_id"].to_i == 0
					tweet_cnt += 1
					@latest_tweet_id = t["id_str"] if t["id_str"] && created >= newest
				end
			end

		end

		days = (newest - oldest >= 1) ? newest - oldest : 1
		@tpd = (tweet_cnt / days).to_f.round(1)
		@rtpd = (retweet_cnt / days).to_f.round(1)
		@combpd = (@tpd + @rtpd).to_f.round(1)
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

	def get_recent_tweet_html
		puts @latest_tweet_id
		#foo = "\u003Cblockquote class=\"twitter-tweet\" width=\"515\"\u003E\u003Cp\u003EHead of \u003Ca href=\"https:\/\/twitter.com\/search\/%23Java\"\u003E#Java\u003C\/a\u003E \u003Ca href=\"https:\/\/twitter.com\/search\/%23security\"\u003E#security\u003C\/a\u003E at Oracle: We'll fix Java and communicate better \u003Ca href=\"http:\/\/t.co\/QbpGgZgI\" title=\"http:\/\/www.computerworld.com\/s\/article\/9236230\/Oracle_s_Java_security_head_We_will_fix_Java_communicate_better?taxonomyId=17\"\u003Ecomputerworld.com\/s\/article\/9236\u2026\u003C\/a\u003E\u003C\/p\u003E&mdash; StopBadware (@stopbadware) \u003Ca href=\"https:\/\/twitter.com\/stopbadware\/status\/294928868689719299\"\u003EJanuary 25, 2013\u003C\/a\u003E\u003C\/blockquote\u003E\n\u003Cscript async src=\"\/\/platform.twitter.com\/widgets.js\" charset=\"utf-8\"\u003E\u003C\/script\u003E"
		"\u003Cblockquote class=\"twitter-tweet\" width=\"515\"\u003E\u003Cp\u003EU.S. Senate will \"prioritize\" passage of cybersecurity bill that seeks to increase public-private information sharing \u003Ca href=\"http:\/\/t.co\/L3jY5c7s\" title=\"http:\/\/threatpost.com\/en_us\/blogs\/senate-introduces-cybersecurity-bill-prioritizes-info-sharing-012413\"\u003Ethreatpost.com\/en_us\/blogs\/se\u2026\u003C\/a\u003E\u003C\/p\u003E&mdash; StopBadware (@stopbadware) \u003Ca href=\"https:\/\/twitter.com\/stopbadware\/status\/294840670571593728\"\u003EJanuary 25, 2013\u003C\/a\u003E\u003C\/blockquote\u003E\n\u003Cscript async src=\"\/\/platform.twitter.com\/widgets.js\" charset=\"utf-8\"\u003E\u003C\/script\u003E"
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