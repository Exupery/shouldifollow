require "open-uri"
require "json"
require "date"
require "timeout"

class Twitterer 
	@@user_url = "https://api.twitter.com/1.1/users/show.json?screen_name="
	@@tweet_url = "https://api.twitter.com/1.1/statuses/user_timeline.json?count=200&include_rts=1&screen_name="
	@@oembed_url = "https://api.twitter.com/1.1/statuses/oembed.json?maxwidth=500&id="

	@@rate_limit_err = "Whoa! shouldifollow seems to have hit the Twitter API hourly rate limit."
	@@no_user_err = "Username not found"
	@@gen_err = "Whoops, something went wrong :-("
	@@timeout_err = "OH NOES - looks likes there was some trouble accessing the Twitter API :-("

	def initialize uname
		@uname = uname
		@id = nil
		@error = nil
		@tpd = Hash.new
		@rtpd = Hash.new
		@allpd = 0
		@latest_tweet_id = nil
		@protected = false
		user = User.new
		@twitter = user.client if user

		begin
			fetch = Timeout::timeout(8) {
				fetch_id_and_allpd
				fetch_t_rt_pd if (@id && !@protected)
			}
		rescue Timeout::Error => ex
			Rails.logger.error "TIMEOUT=>#{ex}"
			@error = @@timeout_err
		end
	end

	def fetch_id_and_allpd
		begin
			response = @twitter.request(:get, @@user_url+@uname)
			json = JSON.parse(response.body)
		rescue OpenURI::HTTPError => ex
			Rails.logger.error "ERROR=>#{ex.to_s}=>#{@@user_url+@uname}"
			if ex.to_s.start_with?("404")
				@error = @@no_user_err 
			elsif ex.to_s.start_with?("420")
				@error = @@rate_limit_err 
			else
				@error = @@gen_err
			end
		rescue => ex
			Rails.logger.error "ERROR=>#{ex.to_s}=>#{@@user_url+@uname}"
			@error = @@gen_err
		end

		if json && json["errors"]
			@error = generate_error json
		elsif json
			@id = json["id_str"]
			@protected = json["protected"]
			@allpd = calc_allpd json["statuses_count"], json["created_at"]
		end
		Rails.logger.error "ERROR=>#{@error}" if @error
	end

	def fetch_t_rt_pd
		begin
			response = @twitter.request(:get, @@tweet_url+@uname)
			json = JSON.parse(response.body)
		rescue OpenURI::HTTPError => ex
			Rails.logger.error "ERROR=>#{ex.to_s}=>#{@@tweet_url+@uname}"
			@error = (ex.to_s.start_with?("420")) ? @@rate_limit_err : @@gen_err
		rescue => ex
			Rails.logger.error "ERROR=>#{ex.to_s}=>#{@@tweet_url+@uname}"
			@error = @@gen_err
		end
		
		if json.kind_of?(Array)
			parse_results json
		else
			@error = generate_error json
		end
		Rails.logger.error "ERROR=>#{@error}" if @error
	end

	def parse_results tweets
		now = Time.now

		week_tweet_cnt = 0;
		week_retweet_cnt = 0;
		week_ago = 7.days.ago
		week_oldest = now
		
		month_tweet_cnt = 0;
		month_retweet_cnt = 0;
		month_ago = 30.days.ago
		month_oldest = now

		tweets.each do |t|
			if t["created_at"] && t["text"]
				created = Time.parse(t["created_at"])
				if t["retweeted_status"] || t["text"].start_with?("RT")
					if created >= week_ago
						week_retweet_cnt += 1
						week_oldest = created if created < week_oldest
					end
					if created >= month_ago
						month_retweet_cnt += 1
						month_oldest = created if created < month_oldest
					end
				elsif t["in_reply_to_user_id"].nil?
					if created >= week_ago
						week_tweet_cnt += 1
						week_oldest = created if created < week_oldest
					end
					if created >= month_ago
						month_tweet_cnt += 1
						month_oldest = created if created < month_oldest
					end
					@latest_tweet_id = t["id_str"] if t["id_str"] && (!@latest_tweet_id || t["id_str"] > @latest_tweet_id)
				end
			end
		end

		week_day_cnt = (now - week_oldest) / 60 / 60 / 24
		week_day_cnt = 1 if week_day_cnt < 1
		month_day_cnt = (now - month_oldest) / 60 / 60 / 24
		month_day_cnt = 1 if month_day_cnt < 1

		@tpd["week"] = (week_tweet_cnt / week_day_cnt).to_f.round(1)
		@tpd["month"] = (month_tweet_cnt / month_day_cnt).to_f.round(1)
		@rtpd["week"] = (week_retweet_cnt / week_day_cnt).to_f.round(1)
		@rtpd["month"] = (month_retweet_cnt / month_day_cnt).to_f.round(1)
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
			elsif code==34
				@@no_user_err
			elsif err["message"] 
				err["message"] 
			end
		else
			@@gen_err
		end
	end

	def get_recent_tweet_html
		if @latest_tweet_id 
			begin
				response = @twitter.request(:get, @@oembed_url+@latest_tweet_id)
				json = JSON.parse(response.body)
				json["html"]
			rescue
				Rails.logger.error "ERROR=>#{@@user_url+@uname}"
				return "<h3 class=\"error\">Unable to retrieve latest tweet - better luck next time!</h3>"
			end
		else
			nil
		end
	end

	def error
		@error
	end

	def uname
		@uname
	end

	def tweets_per_day period
		if @tpd.has_key?(period)
			@tpd[period]
		else
			0
		end
	end

	def retweets_per_day period
		if @rtpd.has_key?(period)
			@rtpd[period]
		else
			0
		end
	end

	def combined_per_day period
		if @tpd.has_key?(period) && @rtpd.has_key?(period)
			(@tpd[period] + @rtpd[period]).to_f.round(1)
		else
			0
		end
	end

	def all_per_day
		@allpd
	end

	def has_latest_tweet?
		@latest_tweet_id
	end

	def is_user_not_found?
		return @error && (@error == @@no_user_err)
	end

	def is_protected?
		@protected
	end

end