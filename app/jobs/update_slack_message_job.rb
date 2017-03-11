require "slack_api"

class UpdateSlackMessageJob < ApplicationJob
  def perform(message_attributes)
    slack_api = SlackAPI::Client.new(token: ENV["SLACK_OAUTH_TOKEN"])
    slack_api.chat_update(message_attributes)
  end
end
