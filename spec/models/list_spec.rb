require "rails_helper"

RSpec.describe List, type: :model do
  fixtures :lists, :users

  it "generates a webhook_token before create" do
    list = List.new(name: "foo", slack_channel_id: "C1")
    expect(list.webhook_token).to be_nil
    list.save!
    expect(list.webhook_token).to be_present
  end

  it "does not regenerate the webhook_token on update" do
    list = lists(:outofdate)
    expect do
      list.update!(name: "outofdate2")
    end.to_not change { list.webhook_token }
  end

  describe "#next_user" do
    let(:list) { lists(:outofdate) }

    it "is the first user when no previous users have been assigned" do
      expect(list.tasks.size).to eq(0)
      expect(list.next_user).to eq(users(:aldhsu))
    end

    it "is the second user when the first user was previously assigned" do
      create_tasks(:aldhsu)
      expect(list.tasks.size).to eq(1)
      expect(list.next_user).to eq(users(:alex))
    end

    it "is still the second user when the second user archived" do
      _, second = create_tasks(:aldhsu, :alex)
      second.archived!
      expect(list.tasks.size).to eq(2)
      expect(list.next_user).to eq(users(:alex))
    end

    it "is the third user when the second user was previously assigned" do
      create_tasks(:aldhsu, :alex)
      expect(list.tasks.size).to eq(2)
      expect(list.next_user).to eq(users(:dave))
    end

    it "is the forth user when the second user was previously assigned" do
      create_tasks(:aldhsu, :alex, :dave)
      expect(list.tasks.size).to eq(3)
      expect(list.next_user).to eq(users(:tate))
    end

    it "is the first user when the previously assigned user is the last user on the list" do
      create_tasks(:aldhsu, :alex, :dave, :tate)
      expect(list.tasks.size).to eq(4)
      expect(list.next_user).to eq(users(:aldhsu))
    end

    it "ignores new records" do
      list.tasks.build(user: users(:aldhsu))
      expect(list.tasks.size).to eq(1)
      expect(list.tasks.count).to eq(0)
      expect(list.next_user).to eq(users(:aldhsu))
    end

    def create_tasks(*keys)
      keys.map do |key|
        list.tasks.create!(description: "rails (5.0.2.rc1)", user: users(key), status: :accepted)
      end
    end
  end
end
