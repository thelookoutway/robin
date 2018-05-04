class ChangeUserMandatoryToTasks < ActiveRecord::Migration[5.1]
  def change
    change_column_null :tasks, :user_id, true
  end
end
