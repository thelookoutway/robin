Rails.application.routes.draw do
  post "/lists/:list_webhook_token/tasks", to: "tasks#create"
  post "/slack/actions", to: "slack_actions#create"
end
