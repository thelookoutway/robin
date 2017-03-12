require "operation"

class RespondToSlackActionOperation < Operation::Base
  def call(params)
    slack_action = SlackAction.new(params)
    unless slack_action.valid?
      return failure
    end

    case slack_action.value
    when :accept then accept(slack_action)
    when :reassign then reassign(slack_action)
    when :archive then archive(slack_action)
    else
      raise "unexpected value: #{payload.value}"
    end
    success
  end

  private

  def accept(slack_action)
    slack_action.task.accepted!
    SlackMessage.new.post_task_accepted(ts: slack_action.ts, task: slack_action.task)
  end

  def reassign(slack_action)
    slack_action.task.reassigned!
    SlackMessage.new.post_task_reassigned(ts: slack_action.ts, task: slack_action.task)
    CreateTaskOperation.new.call(
      list_webhook_token: slack_action.task.list_webhook_token,
      description: slack_action.task.description,
    )
  end

  def archive(slack_action)
    slack_action.task.archived!
    SlackMessage.new.post_task_archived(ts: slack_action.ts, task: slack_action.task)
  end
end
