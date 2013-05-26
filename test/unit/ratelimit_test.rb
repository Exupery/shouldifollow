require "test_helper"
 
class RatelimitTest < ActiveSupport::TestCase
	
	@@limits = Ratelimit.new

	test "gets user lookup limit remaining" do
		assert !@@limits.user_lookups.nil?, "limit remaining is NIL"
    assert @@limits.user_lookups.kind_of?(Numeric), "limit remaining is NOT a number"
	end

	test "gets timeline limit remaining" do
		assert !@@limits.timelines.nil?, "limit remaining is NIL"
    assert @@limits.timelines.kind_of?(Numeric), "limit remaining is NOT a number"
	end

	test "gets oembed limit remaining" do
		assert !@@limits.oembeds.nil?, "limit remaining is NIL"
    assert @@limits.oembeds.kind_of?(Numeric), "limit remaining is NOT a number"
	end

end