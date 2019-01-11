class AddUserIdToCarts < ActiveRecord::Migration[5.2]
  def change
    change_table :carts do |t|
      t.references :user, :after => :token
    end

    # Below, we use :nullify in the case when user might be deleted but we want to remain this row because of cart history
    add_foreign_key :carts, :users, on_update: :cascade, on_delete: :nullify
  end
end
