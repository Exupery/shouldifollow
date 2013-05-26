require "test_helper"
 
class RatelimitTest < ActiveSupport::TestCase
	
	@@limits = Ratelimit.new

	test "gets user lookup limit remaining" do
		assert !@@limits.user_lookups.nil?, "limit remaining is NIL"
    assert @@limits.user_lookups.kind_of?(Hash), "limit remaining is NOT a Hash"
    assert !@@limits.user_lookups["remaining"].nil?, "'remaining' is NOT present"
    assert @@limits.user_lookups["remaining"].kind_of?(Numeric), "'remaining' value is NOT a number"
    assert !@@limits.user_lookups["limit"].nil?, "'limit' is NOT present"
    assert @@limits.user_lookups["limit"].kind_of?(Numeric), "'limit' value is NOT a number"
    assert !@@limits.user_lookups["reset"].nil?, "'reset' is NOT present"
    assert @@limits.user_lookups["reset"].kind_of?(Numeric), "'reset' value is NOT a number"
	end

	test "gets timeline limit remaining" do
		assert !@@limits.timelines.nil?, "limit remaining is NIL"
    assert @@limits.timelines.kind_of?(Hash), "limit remaining is NOT a Hash"
    assert !@@limits.timelines["remaining"].nil?, "'remaining' is NOT present"
    assert @@limits.timelines["remaining"].kind_of?(Numeric), "'remaining' value is NOT a number"
    assert !@@limits.timelines["limit"].nil?, "'limit' is NOT present"
    assert @@limits.timelines["limit"].kind_of?(Numeric), "'limit' value is NOT a number"
    assert !@@limits.timelines["reset"].nil?, "'reset' is NOT present"
    assert @@limits.timelines["reset"].kind_of?(Numeric), "'reset' value is NOT a number"
	end

	test "gets oembed limit remaining" do
		assert !@@limits.oembeds.nil?, "limit remaining is NIL"
    assert @@limits.oembeds.kind_of?(Hash), "limit remaining is NOT a Hash"
    assert !@@limits.oembeds["remaining"].nil?, "'remaining' is NOT present"
    assert @@limits.oembeds["remaining"].kind_of?(Numeric), "'remaining' value is NOT a number"
    assert !@@limits.oembeds["limit"].nil?, "'limit' is NOT present"
    assert @@limits.oembeds["limit"].kind_of?(Numeric), "'limit' value is NOT a number"
    assert !@@limits.oembeds["reset"].nil?, "'reset' is NOT present"
    assert @@limits.oembeds["reset"].kind_of?(Numeric), "'reset' value is NOT a number"
	end

end