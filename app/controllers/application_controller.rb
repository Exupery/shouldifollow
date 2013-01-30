class ApplicationController < ActionController::Base
  protect_from_forgery
  #caches_page :home #TODO partial caching

  def home
    if params[:uname]
      uname = clean params[:uname]
      puts uname
      @title = "Should I Follow @#{uname}?"
      @description = "Displays average tweets per day for @#{uname}"
    else
      @title = "Should I Follow?"
      @description = "Displays average tweets per day for a Twitter user"
    end
  end

  def search
    uname = clean params[:uname]
    puts uname
  	redirect_to "/#{uname}"
  end

  def clean input
    return input.gsub!(/[@<>%'";]/, '') if input
  end

end
