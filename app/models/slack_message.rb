class SlackMessage
  def post_task_assigned(task:)
    CreateSlackMessageJob.perform_later(
      channel: task.slack_channel_id,
      text: "*New #{task.list_name}*\n```#{task.description}```",
      attachments: [
        {
          text: "<@#{task.slack_user_id}> Hey, I've got a new task for you. Can you do it?",
          callback_id: task.id,
          actions: [
            {
              name: "acceptance",
              text: "Accept",
              type: "button",
              value: "accept",
              style: "primary",
            },
            {
              name: "acceptance",
              text: "Reassign",
              type: "button",
              value: "reassign",
            },
            {
              name: "acceptance",
              text: "Archive",
              type: "button",
              value: "archive",
            },
          ],
        },
      ],
    )
  end

  def post_task_unassigned(task:)
    CreateSlackMessageJob.perform_later(
      channel: task.slack_channel_id,
      text: "*New #{task.list_name}*\n```#{task.description}```\nTASK UNASSIGNED. No suitable candidates available.",
    )
  end

  def post_task_accepted(ts:, task:)
    UpdateSlackMessageJob.perform_later(
      ts: ts,
      channel: task.slack_channel_id,
      text: "*#{task.list_name}*\n```#{task.description}```\n✅ <@#{task.slack_user_id}> accepted.",
      attachments: []
    )
  end

  def post_task_reassigned(ts:, task:)
    UpdateSlackMessageJob.perform_later(
      ts: ts,
      channel: task.slack_channel_id,
      text: "*#{task.list_name}*\n```#{task.description}```\n↪️ <@#{task.slack_user_id}> reassigned.",
      attachments: []
    )
  end

  def post_task_archived(ts:, task:)
    UpdateSlackMessageJob.perform_later(
      ts: ts,
      channel: task.slack_channel_id,
      text: "*#{task.list_name}*\n```#{task.description}```\n🗄 <@#{task.slack_user_id}> archived. <@#{task.slack_user_id}> will still be the next person to get assigned for #{task.list_name}.",
      attachments: []
    )
  end
end
