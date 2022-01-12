class AddOrderToInstances < ActiveRecord::Migration[5.2]
  def change
    add_column :instances, :order, :integer, null: false
    add_index :instances, :order
  end
end
