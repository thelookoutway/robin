class ChangeStatusNullOnTasks < ActiveRecord::Migration[5.2]
  def change
    change_column_null :tasks, :status, false
    add_index :tasks, :status
  end
end
