Simplelogin::Application.routes.draw do

  # get "home" => "tickets"

  # Routes for the Visitor
  get "visitor/wait"
  post "visitor/callback"
  post "visitor/update"

  # Routes for the Agent
  get "tickets/take"
  get "tickets/closed"
  resources :tickets

  resources :tickets do
    member do
      get 'take'
      post 'newrecording'
      get 'recordingdetail'
    end
  end

  # Demo pages
  get "demo/plain"
  get "demo/lightbox"

  # API
  get "api/token"
  get "api/appid"
  get "api/friends"
  get "api/me"
  get "auth/login"
  post "auth/login"
  get "auth/logout"

  # Auth Token for Agent
  post "rtcc/callback"

  # CloudRecorder proxy methods and receiver callback
  post "cloudrecorder/recording"
  get "cloudrecorder/detail"
  post "cloudrecorder/receiver"


  # You can have the root of your site routed with "root"
  root 'tickets#index'

end
