class ApplicationController < ActionController::Base
  protect_from_forgery
  caches_page :home
  
  def home
  	uname = params[:uname];
    if uname
      uname.gsub!(/[@<>]/, '')
      @title = "Should I Follow @#{uname}?"
      @description = "Displays average tweets per day for @#{uname}"
    else
      @title = "Should I Follow?"
      @description = "Displays average tweets per day for a Twitter user"
    end
  end

  def search
  	redirect_to "/#{params[:uname]}"
  end

end
