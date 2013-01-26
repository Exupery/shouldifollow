class ApplicationController < ActionController::Base
  protect_from_forgery

  def home
	@title = "Should I Follow?"
	@description = "Displays average tweets per day for a Twitter user"
  end

  def uname
  	logger.debug "***in uname w/#{params[:uname]}***"
	@title = "Should I Follow #{params[:uname]}?"
  end

  def search
  	logger.debug "***in search w/#{params[:uname]}***"
  	redirect_to "/#{params[:uname]}"
  end

end
