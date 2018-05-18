require "rails_helper"

RSpec.describe User, type: :model do
  fixtures :users
  
  describe "#excluded?" do
    it "returns true for current excluded user data" do
      user = users(:alex)
      user.update!(excluded_at: Time.current.beginning_of_minute)
      expect(user.excluded?).to eq(true)
    end

    it "returns false for nil excluded user data" do
      user = users(:aldhsu)
      user.update!(excluded_at: nil)
      expect(user.excluded?).to eq(false)
    end

    it "returns false for future excluded user data" do
      user = users(:aldhsu)
      user.update!(excluded_at: Time.current.advance(years: 1))
      expect(user.excluded?).to eq(false)
    end
  end
end
