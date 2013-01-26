Shouldifollow::Application.routes.draw do
  root :to => "application#home"
  match "/:uname" => "application#user"
end
