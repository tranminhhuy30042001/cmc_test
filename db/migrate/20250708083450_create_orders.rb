class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_price, precision: 12, scale: 2, null: false
      t.string :status, null: false, default: 'pending'
      t.string :payment_method
      t.jsonb :payment_info, default: {}
    end
  end
end
