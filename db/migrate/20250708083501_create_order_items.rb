class CreateOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :asset, null: false, foreign_key: true
      t.decimal :price_at_purchase, precision: 10, scale: 2, null: false
      t.integer :quantity, null: false, default: 1
    end
  end
end
