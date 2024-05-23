class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :buyer, foreing_key: { to_table: :users }, null: false
      t.references :store, foreing_key: true, null: false
      t.timestamps
    end
  end
end
