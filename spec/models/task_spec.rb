require "rails_helper"

RSpec.describe Task, type: :model do
  fixtures :users, :lists

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

  describe "#instigator_id" do
    it "may have instigator" do
      task = Task.new(
        description: "hh",
        user: users(:alex),
        instigator: users(:tate),
        list: lists(:outofdate),
      )
      expect(task.save).to eq(true)
    end

    it "may not have instigator" do
      task = Task.new(
        description: "hh",
        user: users(:alex),
        instigator: nil,
        list: lists(:outofdate),
      )
      expect(task.save).to eq(true)
    end
  end
end
