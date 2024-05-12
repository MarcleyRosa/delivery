class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :buyer, null: false
      t.references :store, null: false
      t.timestamps
    end
  end
end
