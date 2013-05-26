require "test_helper"
 
class UserTest < ActiveSupport::TestCase

  @@user = User.new

  test "oauth token generated" do
    assert !@@user.client.nil?, "oauth client is NIL"
    assert @@user.client.kind_of?(OAuth::AccessToken), "user.client is NOT OAuth::AccessToken"
  end
end