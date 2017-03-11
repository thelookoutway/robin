class SlackAction
  attr_reader :value, :ts, :task

  def initialize(attributes = {})
    @value = extract_value(attributes)
    @task = extract_task(attributes)
    @token = extract_token(attributes)
    @ts = extract_ts(attributes)
  end

  def valid?
    value.present? && ts.present? && task.present? &&
      @token.present? && @token == ENV["SLACK_VERIFICATION_TOKEN"]
  end

  private

  def extract_value(attributes)
    actions = attributes["actions"]
    unless actions
      return
    end

    action = actions.first
    unless action
      return
    end

    value = action["value"]
    value.to_sym if value.respond_to?(:to_sym)
  end

  def extract_task(attributes)
    Task.last
  end

  def extract_token(attributes)
    attributes["token"]
  end

  def extract_ts(attributes)
    attributes["message_ts"]
  end
end
