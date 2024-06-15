class AddStockToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :stock, :integer, default: 0, null: false
  end
end
