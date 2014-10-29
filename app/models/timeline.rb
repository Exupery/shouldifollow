class Timeline

	attr_reader :user_id, :latest_tweet_id, :tweets_per_day, :retweets_per_day, :timeframes, :peak_percent, 
		:weekday_percent, :weekend_percent

	@@seconds_per_day = 60 * 60 * 24

	def initialize user_id, timeline_json
		@user_id = user_id
		@latest_tweet_id = nil
		@oldest_tweet_id = nil
		@oldest_tweet_time = Time.now.utc
		@tweets_per_day = Hash.new
		@retweets_per_day = Hash.new
		
		@num_hashtags = {"week" => 0, "month" => 0}
		@hashtags = {"week" => Hash.new(0), "month" => Hash.new(0)}

		@num_retweeted = {"week" => 0, "month" => 0}

		@weekday_cnt = Hash.new
		@weekend_cnt = Hash.new
		@weekday_percent = Hash.new
		@weekend_percent = Hash.new
		@peak_percent = 1.0

		@timeframes = Array(0..23)
		@timeframes.each { |tf|
			@weekday_cnt[tf] = 0.0
			@weekday_percent[tf] = 0.0
			@weekend_cnt[tf] = 0.0
			@weekend_percent[tf] = 0.0
		}

		@week_ago = 7.days.ago
		@month_ago = 30.days.ago
		@counts = {
			"week_tweet_cnt" => 0,
			"week_retweet_cnt" => 0,
			"week_oldest" => Time.now.utc,
			"month_tweet_cnt" => 0,
			"month_retweet_cnt" => 0,
			"month_oldest" => Time.now.utc
		}

		parse_timeline timeline_json, true
		num_prev = 0
		while num_prev < 2 && @oldest_tweet_time >= @month_ago do
			parse_prev_timeline_batch
			num_prev += 1
		end
		process_timeline
		calc_timing @counts["week_tweet_cnt"] + @counts["week_retweet_cnt"] + @counts["month_tweet_cnt"] + @counts["month_retweet_cnt"]
		if @oldest_tweet_time > @week_ago
			## For extremely active accounts (> 600 tweets a week) estimate hashtag usage and retweeted by others
			days = (Time.now.utc - @counts["week_oldest"]) / @@seconds_per_day	

			num_hashtags_week = @num_hashtags["week"]
			@num_hashtags["week"] = (num_hashtags_week / days * 7).floor
			@num_hashtags["month"] = (num_hashtags_week / days * 30).floor

			num_retweeted_week = @num_retweeted["week"]
			@num_retweeted["week"] = (num_retweeted_week / days * 7).floor
			@num_retweeted["month"] = (num_retweeted_week / days * 30).floor
		end
	end

	def parse_timeline tweets, include_week
		tweets.each do |t|
			if t["created_at"] && t["text"]
				created = Time.parse(t["created_at"]).utc
				add_to_times created
				@oldest_tweet_time = [created, @oldest_tweet_time].min

				is_rt = t["retweeted_status"] || t["text"].start_with?("RT")
				is_reply = !t["in_reply_to_user_id"].nil?

				if include_week && created >= @week_ago
					@counts["week_retweet_cnt"] += 1 if is_rt
					@counts["week_tweet_cnt"] += 1 unless is_reply || is_rt
					@counts["week_oldest"] = [created, @counts["week_oldest"]].min
				end

				if created >= @month_ago
					@counts["month_retweet_cnt"] += 1 if is_rt
					@counts["month_tweet_cnt"] += 1 unless is_reply || is_rt
					@counts["month_oldest"] = [created, @counts["month_oldest"]].min
					parse_hashtags t["entities"]["hashtags"], created < @week_ago unless is_rt
				end
					
				if t["id_str"] && !is_rt && !is_reply
					@latest_tweet_id = t["id_str"] if @latest_tweet_id.nil? || (t["id_str"].to_i > @latest_tweet_id.to_i)
					@oldest_tweet_id = t["id_str"] if @oldest_tweet_id.nil? || (t["id_str"].to_i < @oldest_tweet_id.to_i)
					@num_retweeted["week"] += t["retweet_count"] if include_week && created >= @week_ago
					@num_retweeted["month"] += t["retweet_count"]
				end

			end
		end
	end

	def process_timeline
		now = Time.now.utc

		days = (now - @counts["week_oldest"]) / @@seconds_per_day	
		@tweets_per_day["week"] = calc_per_day_counts @counts["week_tweet_cnt"], days
		@retweets_per_day["week"] = calc_per_day_counts @counts["week_retweet_cnt"], days

		month_oldest = @oldest_tweet_time < @counts["month_oldest"] ? @month_ago : @counts["month_oldest"]
		days = (now - month_oldest) / @@seconds_per_day
		@tweets_per_day["month"] = calc_per_day_counts @counts["month_tweet_cnt"], days
		@retweets_per_day["month"] = calc_per_day_counts @counts["month_retweet_cnt"], days
	end

	def parse_hashtags hashtags, month_only
		hashtags.each do |h|
			unless month_only
				@hashtags["week"][h["text"]] += 1
				@num_hashtags["week"] += 1
			end
			@hashtags["month"][h["text"]] += 1
			@num_hashtags["month"] += 1
		end
	end

	def parse_prev_timeline_batch
		url = "https://api.twitter.com/1.1/statuses/user_timeline.json?count=200&include_rts=1&user_id=#{@user_id}&max_id=#{@oldest_tweet_id}"
		begin
			response = User.new.client.request(:get, url)
			json = JSON.parse(response.body)
			parse_timeline json, false if json.kind_of?(Array)
		rescue => ex
			Rails.logger.error "ERROR=>#{ex.to_s}=>#{url}"
		end
	end

	def calc_per_day_counts cnt, days
		(days>0) ? (cnt / days).to_f.round(1) : 0
	end

	def add_to_times t
		wday = t.wday
		hour = t.hour
		(wday == 0 || wday == 6) ? @weekend_cnt[@timeframes[hour]] += 1 : @weekday_cnt[@timeframes[hour]] += 1
	end

	def calc_timing total
		if total > 0
			@timeframes.each do |tf|
				@weekday_percent[tf] = (@weekday_cnt[tf] / total * 100).round
				@weekend_percent[tf] = (@weekend_cnt[tf] / total * 100).round
				@peak_percent = [@weekday_percent[tf], @weekend_percent[tf], @peak_percent].max
			end
		end
	end

	def num_hashtags period
		@num_hashtags[period]
	end

	def num_retweeted period
		@num_retweeted[period]
	end

	def most_used_hashtag period
		most_used = nil
		@hashtags[period].each do |hashtag, count|
			most_used = hashtag if count > @hashtags[period][most_used]
		end
		most_used
	end
end