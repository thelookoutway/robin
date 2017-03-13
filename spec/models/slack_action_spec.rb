require "rails_helper"

RSpec.describe SlackAction, type: :model do
  fixtures :tasks

  it "extracts the task" do
    slack_action = described_class.new({
      "actions" => [
        {
          "name" => "acceptance",
          "type" => "button",
          "value" => "accept"
        }
      ],
      "callback_id" => tasks(:standup1).id.to_s,
      "token" => "secret",
      "message_ts" => "1489398519.757419",
    })
    expect(slack_action.task).to eq(tasks(:standup1))
  end
end
