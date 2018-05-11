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
    expect { list.update!(name: "outofdate2") }
      .not_to change { list.webhook_token }
  end


  describe "#ordered_users" do
    let(:list) { lists(:outofdate) }

    it "returns alphabetical users when no tasks exist" do
      expect(list.ordered_users).to eq([users(:aldhsu), users(:alex), users(:dave), users(:tate)])
    end

    it "returns alphabetical users rotated once when 1 task exists" do
      create_tasks(:aldhsu)
      expect(list.ordered_users).to eq([users(:alex), users(:dave), users(:tate), users(:aldhsu)])
    end

    it "returns reordered users when many task exists" do
      create_tasks(:aldhsu, :alex)
      expect(list.ordered_users).to eq([users(:dave), users(:tate), users(:aldhsu), users(:alex)])
    end

    it "returns alphabetical users when all users have tasks" do
      create_tasks(:aldhsu, :alex, :dave, :tate)
      expect(list.ordered_users).to eq([users(:aldhsu), users(:alex), users(:dave), users(:tate)])
    end

    it "is not affected by archived tasks" do
      _, second = create_tasks(:aldhsu, :alex)
      second.archived!
      expect(list.tasks.size).to eq(2)
      expect(list.ordered_users).to eq([users(:alex), users(:dave), users(:tate), users(:aldhsu)])
    end

    it "is not affected by un-actioned tasks" do
      task = create_tasks(:aldhsu).first
      task.update(status: nil)
      expect(task.status).to be_nil
      expect(list.tasks.size).to eq(1)
      expect(list.ordered_users).to eq([users(:alex), users(:dave), users(:tate), users(:aldhsu)])
    end

    it "ignores new records" do
      list.tasks.build(user: users(:aldhsu))
      expect(list.tasks.size).to eq(1)
      expect(list.tasks.count).to eq(0)
      expect(list.ordered_users).to eq([users(:aldhsu), users(:alex), users(:dave), users(:tate)])
    end
  end

  describe "#instigator_excluded?" do
    it "returns true if instigator must be excluded from selection" do
      listTest = List.new(
        users: [users(:alex)],
        slack_channel_id:"C1",
        name: "instigatorTest",
        instigator_excluded: true,
      )
      expect(listTest.instigator_excluded?).to eq(true)
    end

    it "defaults to false" do
      listTest = List.new(
        users: [users(:alex)],
        slack_channel_id:"C1",
        name: "instigatorTest",
      )
      expect(listTest.instigator_excluded?).to eq(false)
    end
  end

  def create_tasks(*keys)
    keys.map do |key|
      list.tasks.create!(description: "rails (5.0.2.rc1)", user: users(key), status: :accepted)
    end
  end
end
