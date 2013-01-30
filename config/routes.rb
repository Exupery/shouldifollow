Shouldifollow::Application.routes.draw do
	root :to => "application#home"
	#using should-i-follow, Twitter doesn't allow usernames with hyphens so using something that won't interfere with any potential searches
	match "/should-i-follow" => "application#search"
	match "/:uname" => "application#home"
	match "/*a" => "application#notfound" #pro 404 handling here
end
