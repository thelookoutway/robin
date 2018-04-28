require "rails_helper"

RSpec.describe CreateTaskOperation do
  fixtures :lists, :users

  describe "#call" do
    let(:list) { lists(:test) }

    it "posts to Slack" do
      call_operation
      expect(CreateSlackMessageJob).to have_been_enqueued_with_arguments(
        channel: list.slack_channel_id,
        text: "*New #{list.name}*\n```rails (5.0.2.rc1)```",
      )
    end

    it "creates a task with a nil status" do
      expect { call_operation }.to change { Task.count }.by(1)
      expect(Task.last.status).to be_nil
    end

    it "is a success" do
      result = call_operation
      expect(result).to be_success
    end

    def call_operation
      described_class.new.call(
        list_webhook_token: list.webhook_token,
        description: "rails (5.0.2.rc1)",
      )
    end

    context "when excluding a user" do
      let(:list) { lists(:outofdate) }

      it "does not assign an excluded user" do
        expect(list.tasks).to be_empty

        expect do
          described_class.new.call(
            list_webhook_token: list.webhook_token,
            description: "asdf",
            instigator_slack_id: users(:aldhsu).slack_id,
          )
        end.to change { Task.count }.by(1)

        expect(Task.last.user).to eq(users(:alex))
      end
    end
  end
end
