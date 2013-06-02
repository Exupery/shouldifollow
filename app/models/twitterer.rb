require "open-uri"
require "json"
require "date"
require "timeout"

class Twitterer
	#REVERT 
	@@user_url = "https://api.twitter.com/1.1/users/show.json?screen_name="
	@@tweet_url = "https://api.twitter.com/1.1/statuses/user_timeline.json?count=200&include_rts=1&screen_name="
	@@oembed_url = "https://api.twitter.com/1.1/statuses/oembed.json?maxwidth=500&id="
	#REVERT 
	#DELME
	#@@user_url = "http://127.0.0.1/user.json?screen_name="
	#@@tweet_url = "http://127.0.0.1/timeline.json?screen_name="
	#@@oembed_url = "http://127.0.0.1/oembed.json?id="
	#DELME

	@@rate_limit_err = "Whoa! shouldifollow seems to have hit Twitter's API rate limit."
	@@no_user_err = "Username not found"
	@@gen_err = "Whoops, something went wrong :-("
	@@timeout_err = "OH NOES - looks likes there was some trouble accessing the Twitter API :-("

	attr_reader :id, :uname, :error, :latest_tweet_id, :joined, :all_per_day, :timeline

	def initialize uname
		@uname = uname
		@all_per_day = 0
		@protected = false
		user = User.new
		@twitter = user.client if user
		
		begin
			fetch = Timeout::timeout(8) {
				fetch_id_and_allpd
				fetch_per_day_counts if (@id && !@protected)
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
			@joined = format_join_date json["created_at"]
			@protected = json["protected"]
			@all_per_day = calc_allpd json["statuses_count"], json["created_at"]
		end
		Rails.logger.error "ERROR=>#{@error}" if @error
	end

	def format_join_date joined
		date = nil
		if joined
			t = Time.parse(joined)
			date = t.strftime("%-d %B %Y") if t
		end
		date
	end

	def fetch_per_day_counts
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
			@timeline = Timeline.new @id, json
		else
			@error = generate_error json
		end
		Rails.logger.error "ERROR=>#{@error}" if @error
	end

	def calc_allpd count, since
		count = 0 if !count
		days = (since) ? Date.today-Date.parse(since) : 1;
		(count / days).to_f.round(1)
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
		if has_latest_tweet? 
			begin
				response = @twitter.request(:get, @@oembed_url+@timeline.latest_tweet_id)
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

	def tweets_per_day period
		(@timeline && @timeline.tweets_per_day.has_key?(period)) ? @timeline.tweets_per_day[period] : 0
	end

	def retweets_per_day period
		(@timeline && @timeline.retweets_per_day.has_key?(period)) ? @timeline.retweets_per_day[period] : 0
	end

	def combined_per_day period
		(tweets_per_day(period) + retweets_per_day(period)).to_f.round(1)
	end

	def has_latest_tweet?
		@timeline.latest_tweet_id || false
	end

	def is_user_not_found?
		@error && (@error == @@no_user_err)
	end

	def is_protected?
		@protected
	end

end