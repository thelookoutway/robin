require "rails_helper"

RSpec.describe RespondToSlackActionOperation do
  fixtures :lists, :users, :tasks

  describe "#call" do
    let(:task) { tasks(:test1) }

    context "acceptance" do
      it "marks the task as accepted" do
        call_operation_with_accept_value
        expect(task.reload).to be_accepted
      end

      it "posts to Slack" do
        call_operation_with_accept_value
        expect(UpdateSlackMessageJob).to have_been_enqueued_with_arguments(
          ts: "1488540956.000015",
          channel: task.slack_channel_id,
          text: "*#{task.list_name}*\n```#{task.description}```\n✅ <@#{task.slack_user_id}> accepted.",
          attachments: [],
        )
      end

      it "is a success" do
        result = call_operation_with_accept_value
        expect(result).to be_success
      end

      def call_operation_with_accept_value
        call_operation_with(task: task, value: "accept")
      end
    end

    context "reassign" do
      it "marks the task as reassigned" do
        call_operation_with_reassign_value
        expect(task.reload).to be_reassigned
      end

      it "posts to Slack" do
        call_operation_with_reassign_value
        expect(UpdateSlackMessageJob).to have_been_enqueued_with_arguments(
          ts: "1488540956.000015",
          channel: task.slack_channel_id,
          text: "*#{task.list_name}*\n```#{task.description}```\n↪️ <@#{task.slack_user_id}> reassigned.",
          attachments: [],
        )
      end

      it "creates a new task" do
        expect do
          call_operation_with_reassign_value
        end.to change { Task.count }.by(1)
      end

      it "is a success" do
        result = call_operation_with_reassign_value
        expect(result).to be_success
      end

      def call_operation_with_reassign_value
        call_operation_with(task: task, value: "reassign")
      end
    end

    context "archive" do
      it "marks the task as archived" do
        call_operation_with_archive_value
        expect(task.reload).to be_archived
      end

      it "posts to Slack" do
        call_operation_with_archive_value
        expect(UpdateSlackMessageJob).to have_been_enqueued_with_arguments(
          ts: "1488540956.000015",
          channel: task.slack_channel_id,
          text: "*#{task.list_name}*\n```#{task.description}```\n🗄 <@#{task.slack_user_id}> archived. <@#{task.slack_user_id}> will still be the next person to get assigned for #{task.list_name}.",
          attachments: [],
        )
      end

      it "is a success" do
        result = call_operation_with_archive_value
        expect(result).to be_success
      end

      def call_operation_with_archive_value
        call_operation_with(task: task, value: "archive")
      end
    end

    def call_operation_with(task:, value:)
      described_class.new.call(
        "actions" => [{"name" => "acceptance", "type" => "button", "value" => value}],
        "callback_id" => task.id,
        "token" => ENV["SLACK_VERIFICATION_TOKEN"],
        "message_ts"=>"1488540956.000015",
      )
    end
  end
end
