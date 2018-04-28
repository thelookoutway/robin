require "operation"

class CreateTaskOperation < Operation::Base
  def call(params)
    list = List.find_by!(webhook_token: params[:list_webhook_token])
    task = list.tasks.build(
      description: params[:description],
      user: list.next_user(params[:instigator_slack_id]),
    )

    if task.save
      SlackMessage.new.post_task_assigned(task: task)
      success
    else
      failure
    end
  end
end
