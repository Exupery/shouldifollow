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
      @description = "Find average tweet per day metrics for any Twitter user"
    end
  end

  def search
    uname = clean params[:uname]
  	redirect_to "/#{uname}"
  end

  def clean input
    input.gsub!(/[@<>%'";\/]/, '') if input
    return input
  end

  def notfound
    raise ActionController::RoutingError.new('Not Found')
  end

end
