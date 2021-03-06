require "test_helper"
require "json"
 
class TimelineTest < ActiveSupport::TestCase

  @@test_date = DateTime.now.strftime("%a %B %-d 00:00:00 +0000 %Y")

	@@test_json = '[{"created_at":"'+@@test_date+'","id":339041304241659904,"id_str":"339041304241659904","text":"NASA honors the Americans who have served in the military. #ISS astronaut Cassidy on his @USNavy SEAL service: http:\/\/t.co\/cxH4o3T6iL","source":"\u003ca href=\"http:\/\/www.exacttarget.com\/social\" rel=\"nofollow\"\u003eSocialEngage\u003c\/a\u003e","truncated":false,"in_reply_to_status_id":null,"in_reply_to_status_id_str":null,"in_reply_to_user_id":null,"in_reply_to_user_id_str":null,"in_reply_to_screen_name":null,"user":{"id":11348282,"id_str":"11348282","name":"NASA","screen_name":"NASA","location":"","description":"Explore the universe and discover our home planet with @NASA. We usually post in Eastern Time (UTC\/GMT-5).","url":"http:\/\/t.co\/IpvHUzr4tm","entities":{"url":{"urls":[{"url":"http:\/\/t.co\/IpvHUzr4tm","expanded_url":"http:\/\/www.nasa.gov","display_url":"nasa.gov","indices":[0,22]}]},"description":{"urls":[]}},"protected":false,"followers_count":4112691,"friends_count":203,"listed_count":57256,"created_at":"Wed Dec 19 20:20:32 +0000 2007","favourites_count":47,"utc_offset":-18000,"time_zone":"Eastern Time (US & Canada)","geo_enabled":true,"verified":true,"statuses_count":25581,"lang":"en","contributors_enabled":false,"is_translator":false,"profile_background_color":"022330","profile_background_image_url":"http:\/\/a0.twimg.com\/profile_background_images\/856670389\/8b14322ed9f5797d231c65f5b3eff88c.jpeg","profile_background_image_url_https":"https:\/\/si0.twimg.com\/profile_background_images\/856670389\/8b14322ed9f5797d231c65f5b3eff88c.jpeg","profile_background_tile":false,"profile_image_url":"http:\/\/a0.twimg.com\/profile_images\/188302352\/nasalogo_twitter_normal.jpg","profile_image_url_https":"https:\/\/si0.twimg.com\/profile_images\/188302352\/nasalogo_twitter_normal.jpg","profile_banner_url":"https:\/\/pbs.twimg.com\/profile_banners\/11348282\/1369425813","profile_link_color":"0084B4","profile_sidebar_border_color":"FFFFFF","profile_sidebar_fill_color":"F3F2F2","profile_text_color":"000000","profile_use_background_image":true,"default_profile":false,"default_profile_image":false,"following":null,"follow_request_sent":false,"notifications":null},"geo":null,"coordinates":null,"place":null,"contributors":null,"retweet_count":132,"favorite_count":58,"entities":{"hashtags":[{"text":"nasa","indices":[59,63]}],"symbols":[],"urls":[{"url":"http:\/\/t.co\/cxH4o3T6iL","expanded_url":"http:\/\/go.nasa.gov\/16f9AoF","display_url":"go.nasa.gov\/16f9AoF","indices":[111,133]}],"user_mentions":[{"screen_name":"USNavy","name":"U.S. Navy","id":54885400,"id_str":"54885400","indices":[89,96]}]},"favorited":false,"retweeted":false,"possibly_sensitive":false,"lang":"en"},{"created_at":"'+@@test_date+'","id":339024148900757508,"id_str":"339024148900757508","text":"RT @nasahqphoto: #Exp36 crew members @AstroKarenN @astro_luca and Yurchikhin give a thumbs up after a press conference. #nasa  http:\/\/t.co\/\u2026","source":"\u003ca href=\"http:\/\/www.exacttarget.com\/social\" rel=\"nofollow\"\u003eSocialEngage\u003c\/a\u003e","truncated":false,"in_reply_to_status_id":null,"in_reply_to_status_id_str":null,"in_reply_to_user_id":null,"in_reply_to_user_id_str":null,"in_reply_to_screen_name":null,"user":{"id":11348282,"id_str":"11348282","name":"NASA","screen_name":"NASA","location":"","description":"Explore the universe and discover our home planet with @NASA. We usually post in Eastern Time (UTC\/GMT-5).","url":"http:\/\/t.co\/IpvHUzr4tm","entities":{"url":{"urls":[{"url":"http:\/\/t.co\/IpvHUzr4tm","expanded_url":"http:\/\/www.nasa.gov","display_url":"nasa.gov","indices":[0,22]}]},"description":{"urls":[]}},"protected":false,"followers_count":4112691,"friends_count":203,"listed_count":57256,"created_at":"Wed Dec 19 20:20:32 +0000 2007","favourites_count":47,"utc_offset":-18000,"time_zone":"Eastern Time (US & Canada)","geo_enabled":true,"verified":true,"statuses_count":25581,"lang":"en","contributors_enabled":false,"is_translator":false,"profile_background_color":"022330","profile_background_image_url":"http:\/\/a0.twimg.com\/profile_background_images\/856670389\/8b14322ed9f5797d231c65f5b3eff88c.jpeg","profile_background_image_url_https":"https:\/\/si0.twimg.com\/profile_background_images\/856670389\/8b14322ed9f5797d231c65f5b3eff88c.jpeg","profile_background_tile":false,"profile_image_url":"http:\/\/a0.twimg.com\/profile_images\/188302352\/nasalogo_twitter_normal.jpg","profile_image_url_https":"https:\/\/si0.twimg.com\/profile_images\/188302352\/nasalogo_twitter_normal.jpg","profile_banner_url":"https:\/\/pbs.twimg.com\/profile_banners\/11348282\/1369425813","profile_link_color":"0084B4","profile_sidebar_border_color":"FFFFFF","profile_sidebar_fill_color":"F3F2F2","profile_text_color":"000000","profile_use_background_image":true,"default_profile":false,"default_profile_image":false,"following":null,"follow_request_sent":false,"notifications":null},"geo":null,"coordinates":null,"place":null,"contributors":null,"retweeted_status":{"created_at":"'+@@test_date+'","id":339023886668681217,"id_str":"339023886668681217","text":"#Exp36 crew members @AstroKarenN @astro_luca and Yurchikhin give a thumbs up after a press conference. #nasa  http:\/\/t.co\/SbJG7S1wsi","source":"\u003ca href=\"http:\/\/flickr.com\/services\/twitter\/\" rel=\"nofollow\"\u003eFlickr\u003c\/a\u003e","truncated":false,"in_reply_to_status_id":null,"in_reply_to_status_id_str":null,"in_reply_to_user_id":null,"in_reply_to_user_id_str":null,"in_reply_to_screen_name":null,"user":{"id":18164420,"id_str":"18164420","name":"NASA HQ PHOTO","screen_name":"nasahqphoto","location":"Washington, DC","description":"NASA Headquarters Photo Department.\r\nWashington, DC","url":"http:\/\/t.co\/gathv6195O","entities":{"url":{"urls":[{"url":"http:\/\/t.co\/gathv6195O","expanded_url":"http:\/\/www.flickr.com\/photos\/nasahqphoto","display_url":"flickr.com\/photos\/nasahqp\u2026","indices":[0,22]}]},"description":{"urls":[]}},"protected":false,"followers_count":180284,"friends_count":82,"listed_count":5113,"created_at":"Tue Dec 16 15:40:44 +0000 2008","favourites_count":1,"utc_offset":-18000,"time_zone":"Eastern Time (US & Canada)","geo_enabled":false,"verified":true,"statuses_count":834,"lang":"en","contributors_enabled":false,"is_translator":false,"profile_background_color":"1A1B1F","profile_background_image_url":"http:\/\/a0.twimg.com\/profile_background_images\/3616582\/twitter_bkgr.jpg","profile_background_image_url_https":"https:\/\/si0.twimg.com\/profile_background_images\/3616582\/twitter_bkgr.jpg","profile_background_tile":false,"profile_image_url":"http:\/\/a0.twimg.com\/profile_images\/67630775\/button_meatball_normal.png","profile_image_url_https":"https:\/\/si0.twimg.com\/profile_images\/67630775\/button_meatball_normal.png","profile_link_color":"2FC2EF","profile_sidebar_border_color":"181A1E","profile_sidebar_fill_color":"252429","profile_text_color":"666666","profile_use_background_image":true,"default_profile":false,"default_profile_image":false,"following":null,"follow_request_sent":false,"notifications":null},"geo":null,"coordinates":null,"place":null,"contributors":null,"retweet_count":69,"favorite_count":44,"entities":{"hashtags":[{"text":"nasa","indices":[103,108]}],"symbols":[],"urls":[{"url":"http:\/\/t.co\/SbJG7S1wsi","expanded_url":"http:\/\/flic.kr\/p\/eut3if","display_url":"flic.kr\/p\/eut3if","indices":[110,132]}],"user_mentions":[{"screen_name":"AstroKarenN","name":"Karen L. Nyberg","id":1299995892,"id_str":"1299995892","indices":[20,32]},{"screen_name":"astro_luca","name":"Luca Parmitano","id":290876018,"id_str":"290876018","indices":[33,44]}]},"favorited":false,"retweeted":false,"possibly_sensitive":false,"lang":"en"},"retweet_count":69,"favorite_count":0,"entities":{"hashtags":[{"text":"Exp36","indices":[17,23]},{"text":"nasa","indices":[120,125]}],"symbols":[],"urls":[],"user_mentions":[{"screen_name":"nasahqphoto","name":"NASA HQ PHOTO","id":18164420,"id_str":"18164420","indices":[3,15]},{"screen_name":"AstroKarenN","name":"Karen L. Nyberg","id":1299995892,"id_str":"1299995892","indices":[37,49]},{"screen_name":"astro_luca","name":"Luca Parmitano","id":290876018,"id_str":"290876018","indices":[50,61]}]},"favorited":false,"retweeted":false,"lang":"en"}]'
	@@timeline = Timeline.new nil, JSON.parse(@@test_json)

  test "calcs tweets per day" do
  	tpd = @@timeline.tweets_per_day["week"]
    assert !tpd.nil?, "tweets per day is NIL"
    assert tpd.kind_of?(Numeric), "tweets per day is NOT a number"
    assert tpd > 0, "tweets per day is NOT greater than zero"
  end

  test "calcs retweets per day" do
  	rtpd = @@timeline.retweets_per_day["week"]
    assert !rtpd.nil?, "retweets per day is NIL"
    assert rtpd.kind_of?(Numeric), "retweets per day is NOT a number"
    assert rtpd > 0, "retweets per day is NOT greater than zero"
  end

  test "returns most recent tweet id" do
  	tweet = @@timeline.latest_tweet_id
  	assert !tweet.nil?, "recent tweet is NIL"
  	assert !tweet.empty?, "recent tweet id is empty string"
  end

  test "finds number of hashtags used" do
    assert (@@timeline.num_hashtags "week") > 0
    assert (@@timeline.num_hashtags "month") > 0
  end

  test "finds most used hashtag" do
    assert (@@timeline.most_used_hashtag "week") == "nasa"
    assert (@@timeline.most_used_hashtag "month") == "nasa"
  end

  test "returns hash of timing activity" do
  	timeframes = @@timeline.timeframes
  	assert !timeframes.nil?, "timeframes is NIL"
  	assert timeframes.kind_of?(Array), "timeframes is NOT an Array"
  	assert timeframes.length > 0, "timeframe array is EMPTY"
  	timeframes.each { |tf|
  		assert !@@timeline.weekday_percent[tf].nil?, "missing '#{tf}' for weekday"
			assert !@@timeline.weekend_percent[tf].nil?, "missing '#{tf}' for weekend"
  	}
  end
end