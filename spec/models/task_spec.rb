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

    it "is nil if without user" do
      task = Task.create!(
        description: "asdf",
        list: lists(:test),
        status: :unassigned,
        user: nil,
      )
      expect(task.slack_user_id).to be_nil
    end
  end

  describe "#instigator_id" do
    it "may have instigator" do
      task = Task.new(
        description: "hh",
        instigator: users(:tate),
        list: lists(:outofdate),
        status: :assigned,
        user: users(:alex),
      )
      expect(task.save).to eq(true)
    end

    it "may not have instigator" do
      task = Task.new(
        description: "hh",
        instigator: nil,
        list: lists(:outofdate),
        status: :assigned,
        user: users(:alex),
      )
      expect(task.save).to eq(true)
    end
  end

  describe "#user_id" do
    it "may be nil if unassigned" do
      task = Task.new(
        description: "hh",
        list: lists(:outofdate),
        user: nil,
        status: :unassigned,
      )
      expect(task.save).to eq(true)
    end
  end

  describe ".not_unassigned" do
    before(:example) { Task.destroy_all }

    let(:defaults) do
      {
        description: "asdf",
        list: lists(:pull_request),
        user: users(:alex),
      }
    end

    it "excludes unassigned tasks" do
      Task.create!(defaults.merge(status: :unassigned, user: nil))
      expect(Task.not_unassigned).to be_empty
    end

    Task.statuses.except(:unassigned).each_key do |status|
      it "includes #{status} tasks" do
        task = Task.create!(defaults.merge(status: status.to_sym))
        expect(Task.not_unassigned).to contain_exactly(task)
      end
    end
  end

  describe ".not_archived" do
    before(:example) { Task.destroy_all }

    let(:defaults) do
      {
        description: "asdf",
        list: lists(:pull_request),
        user: users(:alex),
      }
    end

    it "excludes archived tasks" do
      Task.create!(defaults.merge(status: :archived))
      expect(Task.not_archived).to be_empty
    end

    Task.statuses.except(:archived, :unassigned).each_key do |status|
      it "includes #{status} tasks" do
        task = Task.create!(defaults.merge(status: status.to_sym))
        expect(Task.not_archived).to contain_exactly(task)
      end
    end

    it "includes unassigned tasks" do
      task = Task.create!(defaults.merge(status: :unassigned, user: nil))
      expect(Task.not_archived).to contain_exactly(task)
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
