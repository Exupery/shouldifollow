class Timeline

	attr_reader :user_id, :latest_tweet_id, :tweets_per_day, :retweets_per_day, :timeframes, :weekday_percent, :weekend_percent

	def initialize user_id, timeline_json
		@user_id = user_id
		@tweets_per_day = Hash.new
		@retweets_per_day = Hash.new
		@weekday_cnt = Hash.new
		@weekend_cnt = Hash.new
		@weekday_percent = Hash.new
		@weekend_percent = Hash.new
		@timeframes = Array(0..23)
		@timeframes.each { |tf|
			@weekday_cnt[tf] = 0.0
			@weekday_percent[tf] = 0.0
			@weekend_cnt[tf] = 0.0
			@weekend_percent[tf] = 0.0
		}
		parse_timeline timeline_json
		calc_timing timeline_json.length if !timeline_json.nil?
	end

	def parse_timeline tweets
		now = Time.now.utc

		week_tweet_cnt = 0
		week_retweet_cnt = 0
		week_ago = 7.days.ago
		week_oldest = now
		
		month_tweet_cnt = 0
		month_retweet_cnt = 0
		month_ago = 30.days.ago
		month_oldest = now

		tweets.each do |t|
			if t["created_at"] && t["text"]
				created = Time.parse(t["created_at"]).utc
				add_to_times created

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
		month_day_cnt = (now - month_oldest) / 60 / 60 / 24
		
		@tweets_per_day["week"] = calc_per_day_counts week_tweet_cnt, week_day_cnt
		@retweets_per_day["week"] = calc_per_day_counts week_retweet_cnt, week_day_cnt
		@tweets_per_day["month"] = calc_per_day_counts month_tweet_cnt, month_day_cnt
		@retweets_per_day["month"] = calc_per_day_counts month_retweet_cnt, month_day_cnt
		#For very active users (>200 tweets per week) month and week stats will be same
		#rounding month up in those cases to reflect less precision
		@tweets_per_day["month"] = @tweets_per_day["month"].ceil if month_day_cnt < 7
		@retweets_per_day["month"] = @retweets_per_day["month"].ceil if month_day_cnt < 7
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
			@timeframes.each { |tf|
				@weekday_percent[tf] = (@weekday_cnt[tf] / total * 100).round
				@weekend_percent[tf] = (@weekend_cnt[tf] / total * 100).round
			}
		end
	end
end