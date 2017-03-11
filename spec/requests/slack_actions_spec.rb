require "rails_helper"

RSpec.describe "/slack/actions", type: :request do
  fixtures :lists, :tasks, :users

  describe "POST /" do
    it "is a success when accepted" do
      task = tasks(:test1)
      post "/slack/actions", params: {payload: JSON.dump({
          # Minimal payload. The actual payload is a lot bigger than this, but this is all we care about.
          "actions" => [{"name" => "acceptance", "type" => "button", "value" => "accept"}],
          "callback_id" => task.id,
          "token" => ENV["SLACK_VERIFICATION_TOKEN"],
          "message_ts" => "1488540956.000015",
        }
      )}
      expect(response).to have_http_status(:ok)
    end

    it "is a bad request when given invalid params" do
      post "/slack/actions", params: {payload: JSON.dump(foo: "bar")}
      expect(response).to have_http_status(:bad_request)
    end

    it "is a bad request when given a nil value" do
      expect do
        post "/slack/actions", params: {payload: nil}
      end.to raise_error(ActionController::ParameterMissing)
    end

    it "is a bad request when given a garbage" do
      post "/slack/actions", params: {payload: ".///##?$.."}
      expect(response).to have_http_status(:bad_request)
    end
  end
end
