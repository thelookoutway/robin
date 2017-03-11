require "slack_api"

class CreateSlackMessageJob < ApplicationJob
  def perform(message_attributes)
    slack_api = SlackAPI::Client.new(token: ENV["SLACK_OAUTH_TOKEN"])
    slack_api.chat_post_message(message_attributes)
  end
end
