class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery

  def home
	uname = params[:uname];
	@title = (uname) ? "Should I Follow #{uname}?" : "Should I Follow?"
	@description = "Displays average tweets per day for a Twitter user"
	if uname
		get_stats(uname)
	else
		toggle_expl
	end
  end

  def search
  	redirect_to "/#{params[:uname]}"
  end

end
