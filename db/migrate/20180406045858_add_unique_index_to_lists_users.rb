class AddUniqueIndexToListsUsers < ActiveRecord::Migration[5.1]
  def change
    remove_index :lists_users, :list_id
    add_index(:lists_users, [:list_id, :user_id], unique: true)
  end
end
