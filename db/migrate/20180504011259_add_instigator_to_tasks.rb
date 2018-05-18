class AddInstigatorToTasks < ActiveRecord::Migration[5.1]
  def change
    add_reference :tasks, :instigator, foreign_key: {to_table: :users}
  end
end
