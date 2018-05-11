require "operation"

class CreateTaskOperation < Operation::Base
  def call(params)
    list = List.find_by!(webhook_token: params[:list_webhook_token])
    task = list.tasks.build(
      description: params[:description],
      instigator: User.find_by(slack_id: params[:instigator_slack_id]),
    )

    if task.save
      task.assign_user

      if task.user.nil?
        SlackMessage.new.post_task_unassigned(task: task)
      else
        SlackMessage.new.post_task_assigned(task: task)
      end
      success
    else
      failure
    end
  end
end
