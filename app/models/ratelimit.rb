require "open-uri"
require "json"
require "timeout"

class Ratelimit

  attr_reader :user_lookups, :timelines, :oembeds

  def initialize
  	@user_lookups = Hash.new
  	@timelines = Hash.new
  	@oembeds = Hash.new
  	update_rate_limits	
  end

  def update_rate_limits
		json = get_json
		if json
			res = json["resources"]
			@user_lookups = res["users"]["/users/show/:id"]
			@timelines = res["statuses"]["/statuses/user_timeline"]
			@oembeds = res["statuses"]["/statuses/oembed"]
		end
  end

  def get_json
  	json = nil
  	user = User.new
  	twitter = user.client if user
  	rate_limit_url = "https://api.twitter.com/1.1/application/rate_limit_status.json?resources=users,statuses"
  	begin
  		fetch = Timeout::timeout(8) {
  			response = twitter.request(:get, rate_limit_url)
  			json = JSON.parse(response.body)
  		}
  	rescue => ex
  		Rails.logger.error "ERROR=>#{ex.to_s}"
  	end

  	if json && json["errors"]
  		Rails.logger.error "API RESPONSE=>#{json["errors"]}"
  	end

  	return json
  end

end