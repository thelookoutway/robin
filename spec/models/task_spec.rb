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

  describe "#user_id" do
    it "may not have a user" do
      task = Task.new(
        description: "hh",
        user:nil,
        list: lists(:outofdate),
      )
      expect(task.save).to eq(true)
    end
  end

  describe ".not_archived" do
    it "excludes archived tasks" do
      Task.destroy_all
      defaults = {
        description: "hh",
        list: lists(:pull_request),
      }
      t1 = Task.create!(defaults.merge(status: nil))
      t2 = Task.create!(defaults.merge(status: :archived))
      t3 = Task.create!(defaults.merge(status: :reassigned))
      t4 = Task.create!(defaults.merge(status: :accepted))
      expect(Task.not_archived).to contain_exactly(t1, t3, t4)
    end
  end

  describe "#assign_user" do
    it "excludes the instigator if requested by the list" do
      list = lists(:pull_request)
      task = Task.new(
        description: "asdf",
        list: list,
        instigator: users(:aldhsu),
        user: nil,
      )
      expect(list.ordered_users.first).to eq(users(:aldhsu))
      expect(task.assign_user).to eq(users(:alex))
    end

    it "assigns the instigator if they are due and the list does not exclude them" do
      list = lists(:outofdate)
      task = Task.new(
        description: "asdf",
        list: list,
        instigator: users(:aldhsu),
        user: nil,
      )
      expect(list.ordered_users.first).to eq(users(:aldhsu))
      expect(task.assign_user).to eq(users(:aldhsu))
    end

    it "eliminates any excluded users and instigator" do
      list = lists(:pull_request)
      task = Task.new(
        description: "asdf",
        list: list,
        instigator: users(:aldhsu),
        user: nil,
      )
      alex = users(:alex)
      alex.update!(excluded_at: Time.current.beginning_of_minute)

      expect(list.ordered_users.first).to eq(users(:aldhsu))
      expect(list.ordered_users.second).to eq(users(:alex))
      expect(alex.excluded?).to eq(true)
      expect(task.assign_user).to eq(users(:dave))
    end

    it "eliminates any excluded users and not the instigator" do
      list = lists(:outofdate)
      task = Task.new(
        description: "asdf",
        list: list,
        instigator: users(:alex),
        user: nil,
      )
      aldhsu = users(:aldhsu)
      aldhsu.update!(excluded_at: Time.current.beginning_of_minute)
      expect(list.ordered_users.first).to eq(users(:aldhsu))
      expect(aldhsu.excluded?).to eq(true)
      expect(task.assign_user).to eq(users(:alex))
    end

    it "is not affected by an irrelevant exclusion" do
      list = lists(:pull_request)
      task = Task.new(
        description: "asdf",
        list: list,
        instigator: users(:alex),
        user: nil,
      )
      alex = users(:alex)
      alex.update!(excluded_at: Time.current.beginning_of_minute)
      expect(list.ordered_users.first).to eq(users(:aldhsu))
      expect(task.assign_user).to eq(users(:aldhsu))
    end

    it "returns nil if no users in list" do
      list = lists(:empty)
      task = Task.new(
        description: "asdf",
        list: list,
        instigator: users(:alex),
        user: nil,
      )
      expect(task.assign_user).to eq(nil)
    end
  end
end
