require "spec_helper"
require "support/vcr"
require "slack_api"

RSpec.describe SlackAPI::Client do
  describe "#chat_post_message" do
    it "creates the message", vcr: "chat_post_message" do
      client = SlackAPI::Client.new(token: "abcd-1234")
      response = client.chat_post_message(
        channel: "C12345",
        text: "Hello",
        attachments: [
          {
            text: "Hello",
            actions: [
              {name: "foo", text: "foo", type: "button", value: "foo"},
            ],
          },
        ]
      )
      expect(response.code).to eq("200")
      expect(response.data).to include("ok" => true)
      expect(response.body).to include("attachments")
    end
  end

  describe "#chat_update" do
    it "updates the message", vcr: "chat_update" do
      client = SlackAPI::Client.new(token: "abcd-1234")
      response = client.chat_update(
        ts: "1489133341.000008",
        channel: "C12345",
        text: "Hello, again",
        attachments: [
          {
            text: "Hello",
            actions: [
              {name: "foo", text: "foo", type: "button", value: "foo"},
            ],
          },
        ]
      )
      expect(response.code).to eq("200")
      expect(response.data).to include("ok" => true)
      expect(response.body).to include("attachments")
    end
  end
end
