class CreateCartItems < ActiveRecord::Migration[5.2]
  def change
    create_table :cart_items do |t|
      t.references :cart
      t.references :products

      t.timestamps
    end

    add_index :cart_items, [:cart_id, :product_id]
    add_foreign_key :cart_items, :carts, on_update: :cascade, on_delete: :cascade
    # Below, we use :nullify in the case when products will be deleted but we want to remain this row because of cart details
    add_foreign_key :cart_items, :products, on_update: :cascade, on_delete: :nullify
  end
end
