class TasksController < ApplicationController
  def create
    result = CreateTaskOperation.new.call(task_params)
    if result.success?
      render(status: :created)
    else
      render(status: :unprocessable_entity)
    end
  end

  private

  def task_params
    params.permit(:list_webhook_token, :description)
  end
end
