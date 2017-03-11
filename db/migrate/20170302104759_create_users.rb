class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :slack_id, null: false
      t.string :slack_name, null: false
      t.timestamps
    end
  end
end
