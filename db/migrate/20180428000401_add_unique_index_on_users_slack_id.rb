class AddUniqueIndexOnUsersSlackId < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :slack_id, unique: true
  end
end
