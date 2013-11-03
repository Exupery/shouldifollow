Shouldifollow::Application.routes.draw do
	root :to => "application#home"
	get "/:uname" => "application#home"
	get "/search/should-i-follow" => "application#search"
	get "/dev/ratelimit" => "application#ratelimit"	#shows rate limit data (dev mode only)
	get "/*a" => "application#notfound" 			#pro 404 handling here
end
