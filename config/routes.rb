Shouldifollow::Application.routes.draw do
	root :to => "application#home"
	match "/:uname" => "application#home"
	match "/search/should-i-follow" => "application#search"
	match "/*a" => "application#notfound" #pro 404 handling here
end
