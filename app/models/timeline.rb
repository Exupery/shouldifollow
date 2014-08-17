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
		@hashtags = {"week" => Hash.new, "month" => Hash.new}

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
		if @counts["week_oldest"] > @week_ago
			## For *extremely* active accounts (> 600 tweets a week) estimate hashtag usage
			week_day_cnt = (Time.now.utc - @counts["week_oldest"]) / @@seconds_per_day	
			@num_hashtags["week"] = (@num_hashtags["week"] / week_day_cnt * 7).floor
			@num_hashtags["month"] = (@num_hashtags["week"] / week_day_cnt * 30).floor
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
					
				if t["id_str"]
					@latest_tweet_id = t["id_str"] if @latest_tweet_id.nil? || (t["id_str"] > @latest_tweet_id)
					@oldest_tweet_id = t["id_str"] if @oldest_tweet_id.nil? || (t["id_str"] < @oldest_tweet_id)
				end

			end
		end
	end

	def process_timeline
		now = Time.now.utc

		week_day_cnt = (now - @counts["week_oldest"]) / @@seconds_per_day	
		@tweets_per_day["week"] = calc_per_day_counts @counts["week_tweet_cnt"], week_day_cnt
		@retweets_per_day["week"] = calc_per_day_counts @counts["week_retweet_cnt"], week_day_cnt

		month_day_cnt = (now - @counts["month_oldest"]) / @@seconds_per_day
		@tweets_per_day["month"] = calc_per_day_counts @counts["month_tweet_cnt"], month_day_cnt
		@retweets_per_day["month"] = calc_per_day_counts @counts["month_retweet_cnt"], month_day_cnt
	end

	def parse_hashtags hashtags, month_only
		hashtags.each do |h|
			#puts h ##DELME
			#puts h["text"] ##DELME
			@num_hashtags["week"] += 1 unless month_only
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
end