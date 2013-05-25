require "test_helper"
 
class TwittererTest < ActiveSupport::TestCase

  def setup
    @tw = Twitterer.new("nasa")
  end

  test "calcs tweets per day" do
  	tpd = @tw.tweets_per_day "week"
  	puts @tw.error
  	puts ">>#{ENV["TWITTER_CONSUMER_KEY"]}<<>>#{ENV["TWITTER_CONSUMER_SECRET"]}<<>>#{ENV["TWITTER_ACCESS_KEY"]}<<>>#{ENV["TWITTER_ACCESS_SECRET"]}<<"	#DELME
  	puts tpd
  	puts tpd.class.name
    assert !tpd.nil?, "tweets per day is NIL"
    assert tpd > 0, "tweets per day is NOT greater than zero"
  end
end