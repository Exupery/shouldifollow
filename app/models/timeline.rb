class Timeline

	attr_reader :user_id, :start_time, :end_time
	attr_accessor :tweets_per_day, :retweets_per_day

	def initialize user_id, timeline_json
		@user_id = user_id
		@start_time = 0
		@end_time = 0
		@tweets_per_day = Hash.new
		@retweets_per_day = Hash.new
		parse_timeline timeline_json
	end

	def parse_timeline json
		
	end
end