require "rails_helper"

RSpec.describe "/lists/:list_id/tasks", type: :request do
  fixtures :lists, :users

  describe "POST /" do
    it "is created when given valid params" do
      list = lists(:test)
      post "/lists/#{list.id}/tasks", params: {description: "rails (5.0.2.rc1)"}
      expect(response).to have_http_status(:created)
    end

    it "is an unprocessable entity when given valid params" do
      list = lists(:test)
      post "/lists/#{list.id}/tasks", params: {description: ""}
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
