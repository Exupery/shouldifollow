Shouldifollow::Application.routes.draw do
	root :to => "application#home"
	match "/search" => "application#search"
	match "/:uname" => "application#uname"
end
