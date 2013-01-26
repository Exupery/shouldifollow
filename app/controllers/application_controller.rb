class ApplicationController < ActionController::Base
  protect_from_forgery
  def home
		@title = "Should I Follow?"
		@description = "Displays average tweets per day for a Twitter user"
  end

  def user
	@title = "FOOBARShould I Follow?"
  end
end
