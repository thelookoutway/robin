class AddSlackChannelIdToLists < ActiveRecord::Migration[5.1]
  def change
    add_column :lists, :slack_channel_id, :string, null: false
  end
end
