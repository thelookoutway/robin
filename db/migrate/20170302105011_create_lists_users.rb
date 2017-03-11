class CreateListsUsers < ActiveRecord::Migration[5.1]
  def change
    create_join_table :lists, :users do |t|
      t.index :list_id
      t.index :user_id
    end

    add_foreign_key :lists_users, :lists
    add_foreign_key :lists_users, :users
  end
end
