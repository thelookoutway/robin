Rails.application.routes.draw do
  post "/slack/actions", to: "slack_actions#create"

  resources :lists, only: [] do
    resources :tasks, only: [:create]
  end
end
