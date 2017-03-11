class AddUserIdToTasks < ActiveRecord::Migration[5.1]
  def change
    add_reference(:tasks, :user, foreign_key: true, null: false)
  end
end
