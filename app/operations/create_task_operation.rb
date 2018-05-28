require "operation"

class CreateTaskOperation < Operation::Base
  def call(params)
    list = List.find_by!(webhook_token: params[:list_webhook_token])
    task = list.tasks.build(
      description: params[:description],
      instigator: User.find_by(slack_id: params[:instigator_slack_id]),
      status: :unassigned,
    )

    if task.save
      task.assign_user

      case task.status
      when "assigned" then SlackMessage.new.post_task_assigned(task: task)
      when "unassigned" then SlackMessage.new.post_task_unassigned(task: task)
      else fail "unexpected status on a new task: #{task.status.inspect}"
      end

      success
    else
      failure
    end
  end
end
