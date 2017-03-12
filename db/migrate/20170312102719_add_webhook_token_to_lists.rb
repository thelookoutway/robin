class AddWebhookTokenToLists < ActiveRecord::Migration[5.1]
  def change
    add_column(:lists, :webhook_token, :string, null: true)

    List.find_each do |list|
      list.update(webhook_token: SecureRandom.hex(64))
    end

    add_index(:lists, :webhook_token, unique: true)
    change_column_null(:lists, :webhook_token, false)
  end
end
