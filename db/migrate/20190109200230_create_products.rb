class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :title, null: false
      t.decimal :price, null: false, unsigned: true, precision: 13, scale: 2
      t.integer :inventory_count, null: false, default: 0

      t.timestamps
    end

    add_index :products, :inventory_count
  end
end
