require "test_helper"
 
class TwittererTest < ActiveSupport::TestCase

  @@tw = Twitterer.new("nasa")

  test "returns tweets per day" do
  	tpd = @@tw.tweets_per_day "week"
    assert !tpd.nil?, "tweets per day is NIL"
    assert tpd.kind_of?(Numeric), "tweets per day is NOT a number"
    assert tpd > 0, "tweets per day is NOT greater than zero"
  end

  test "returns retweets per day" do
  	rtpd = @@tw.retweets_per_day "week"
    assert !rtpd.nil?, "retweets per day is NIL"
    assert rtpd.kind_of?(Numeric), "retweets per day is NOT a number"
    assert rtpd > 0, "retweets per day is NOT greater than zero"
  end

  test "returns combined per day" do
  	cpd = @@tw.combined_per_day "week"
    assert !cpd.nil?, "combined per day is NIL"
    assert cpd.kind_of?(Numeric), "combined per day is NOT a number"
    assert cpd > 0, "combined per day is NOT greater than zero"
  end

  test "returns all per day" do
  	apd = @@tw.all_per_day
    assert !apd.nil?, "all per day is NIL"
    assert apd.kind_of?(Numeric), "all per day is NOT a number"
    assert apd > 0, "all per day is NOT greater than zero"
  end

  test "returns joined date" do
  	joined = @@tw.joined
  	assert !joined.nil?, "joined date is NIL"
  	assert !joined.empty?, "joined date is empty string"
  end

  test "returns most recent tweet" do
  	tweet = @@tw.get_recent_tweet_html
  	assert !tweet.nil?, "recent tweet is NIL"
  	assert !tweet.empty?, "recent tweet is empty string"
  end

  test "user not found" do
  	no_user = Twitterer.new("")
  	assert no_user.is_user_not_found?
  end

  test "user is protected" do
  	shy_user = Twitterer.new("protected")
  	assert shy_user.is_protected?
  end
end