require "test_helper"

class ApplicationControllerTest < ActionController::TestCase

  test "should get home" do
  	get :home
  	assert_response :success
  end

  test "should get ratelimit" do
    get :ratelimit
    assert_response :success
  end

  test "search for SEARCH_FOR should redirect to /SEARCH_FOR" do
  	search_for = "foobar"
  	get :search, :uname => search_for
  	assert_redirected_to "/#{search_for}"
  end

  test "user input should be cleaned" do
  	dirty_chars = ["!","@","%","&","\\","/","?","'","\"",";","=","<",">"]
  	cleaned = @controller.clean "clean#{dirty_chars.join}me" 
  	
  	dirty_chars.each { |c|
  	  assert !cleaned.include?(c), "string should NOT contain '#{c}'"	
  	}
  	assert cleaned == "cleanme"
  end

  test "nonexistant path returns 404" do
  	assert_raises ActionController::UrlGenerationError do
  	  get "/no/such/path/"
  	end
  end

end
