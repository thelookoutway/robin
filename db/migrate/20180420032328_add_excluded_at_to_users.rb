class AddExcludedAtToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :excluded_at, :datetime
  end
end
