require "rails_helper"

RSpec.describe Task, type: :model do
  describe "#slack_channel_id" do
    it "is the list's slack channel id" do
      list = List.new(slack_channel_id: "C1")
      task = list.tasks.build
      expect(task.slack_channel_id).to eq("C1")
    end
  end

  describe "#slack_user_id" do
    it "is the user's slack id" do
      user = User.new(slack_id: "U1")
      task = Task.new(user: user)
      expect(task.slack_user_id).to eq("U1")
    end
  end
end
