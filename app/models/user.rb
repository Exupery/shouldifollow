class User

	def initialize
		puts "new user created"	#DELME
		@twitter = nil
		@auth_success = auth?
		puts @auth_success		#DELME
	end

	def auth?
		#@twitter = Twitter::Client.new(
		#	:consumer_key => ENV["TWITTER_CONSUMER_KEY"],
		#	:consumer_secret => ENV["TWITTER_CONSUMER_SECRET"]
		#	:oauth_token => "",
		#	:oauth_token_secret => ""
		#)

		begin
			#puts @twitter.user_timeline("frostmatthew").first.text
			return true
		rescue Twitter::Error => ex
			puts "TWITTER ERROR=>#{ex.to_s}"	#TODO
		rescue => ex
			puts "ERROR=>#{ex.to_s}"			#TODO
		end

		return false
	end

	#def get_auth_token	#TODO
	#	json = JSON.parse(open("https://api.twitter.com/oauth/request_token").read)
	#end

	def client
		@twitter
	end
end