class AddQtyToCartItems < ActiveRecord::Migration[5.2]
  def change
    add_column :cart_items, :qty, :integer, unsigned: true, null: false, default: 0
  end
end
