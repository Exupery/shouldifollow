class User

	@@cons_key = ENV["TWITTER_CONSUMER_KEY"]
	@@cons_secret = ENV["TWITTER_CONSUMER_SECRET"]
	@@acc_key = ENV["TWITTER_ACCESS_KEY"]
	@@acc_secret = ENV["TWITTER_ACCESS_SECRET"]

	def initialize
		@access_token = create_access_token(@@acc_key, @@acc_secret)
	end

	def create_access_token oauth_token, oauth_token_secret
		consumer = OAuth::Consumer.new(@@cons_key, @@cons_secret, {
				:site => "https://api.twitter.com",
				:scheme => :header
			})
		token_hash = {
			:oauth_token => oauth_token,
			:oauth_token_secret => oauth_token_secret
		}
		access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
		response = access_token.request(:get, "https://api.twitter.com/1/statuses/home_timeline.json")	#DELME
		puts response	#DELME
		return access_token
	end

	def client
		@access_token
	end
end