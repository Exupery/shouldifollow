require "test_helper"
 
class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new
  end

  test "oauth token generated" do
    assert !@user.client.nil?, "oauth client is NIL"
    assert @user.client.kind_of?(OAuth::AccessToken), "user.client is NOT OAuth::AccessToken"
  end
end