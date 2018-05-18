class AddListInstigatorExcludedToLists < ActiveRecord::Migration[5.1]
  def change
    add_column :lists, :instigator_excluded, :bool, null: false, default: false
  end
end
