class CreateCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :carts do |t|
      t.string :token
      t.timestamp :completed_at
      t.decimal :total, unsigned: true, precision: 13, scale: 2 # this is total price at of cart at the moment cart was completed

      t.timestamps
    end

    add_index :carts, [:token, :completed_at]
  end
end
