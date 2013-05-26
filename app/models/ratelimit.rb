require "open-uri"
require "json"
require "timeout"

class Ratelimit

  attr_reader :user_lookups, :timelines, :oembeds

  def initialize
  	update_rate_limits	
  end

  def update_rate_limits
		json = get_json
		if json
			res = json["resources"]
			@user_lookups = res["users"]["/users/show/:id"]["remaining"]
			@timelines = res["statuses"]["/statuses/user_timeline"]["remaining"]
			@oembeds = res["statuses"]["/statuses/oembed"]["remaining"]
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