class SlackActionsController < ApplicationController
  def create
    result = RespondToSlackActionOperation.new.call(slack_action_params)
    if result.success?
      head(:ok)
    else
      head(:bad_request)
    end
  end

  private

  def slack_action_params
    begin
      JSON.parse(params.require(:payload))
    rescue TypeError, JSON::ParserError
      {}
    end
  end
end
