class User

	def initialize
		@access_token = create_access_token(ENV["TWITTER_ACCESS_KEY"], ENV["TWITTER_ACCESS_SECRET"])
	end

	def create_access_token oauth_token, oauth_token_secret
		consumer = OAuth::Consumer.new(ENV["TWITTER_CONSUMER_KEY"], ENV["TWITTER_CONSUMER_SECRET"], {
				:site => "https://api.twitter.com",
				:scheme => :header
			})
		token_hash = {
			:oauth_token => oauth_token,
			:oauth_token_secret => oauth_token_secret
		}
		access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
		return access_token
	end

	def client
		@access_token
	end
end