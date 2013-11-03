class ApplicationController < ActionController::Base
  protect_from_forgery

  def home
    if params[:uname]
      uname = clean params[:uname]
      Rails.logger.info "SEARCH=>#{uname}"
      @title = "Should I Follow @#{uname}?"
      @description = "Average tweets per day for @#{uname}"
    else
      @title = "Should I Follow?"
      @description = "Statistics for frequency and timing of tweets, average tweets per day, and join date for anyone on Twitter!"
    end
  end

  def search
    uname = clean params[:uname]
  	redirect_to "/#{uname}"
  end

  def clean input
    input.gsub!(/[^a-zA-Z0-9_]/, '') if input
    return input
  end

  def ratelimit
  end

  def notfound
    raise ActionController::RoutingError.new("Not Found")
  end

end
