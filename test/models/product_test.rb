require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "product model method is_out_of_stock should return true if product out of stock" do
    products(:out_of_stock).is_out_of_stock?
    assert true
  end

  test "product model method decrease_inventory should decrease by specified amount" do
    decrease_by = 2
    p = products(:one)
    initial_stock = p.inventory_count
    p.decrease_inventory(decrease_by)
    new_stock = p.inventory_count

    assert_equal initial_stock - decrease_by, new_stock
  end

  test "product model method increase_inventory should increase by specified amount" do
    increase_by = 2
    p = products(:one)
    initial_stock = p.inventory_count
    p.increase_inventory(increase_by)
    new_stock = p.inventory_count

    assert_equal initial_stock + increase_by, new_stock
  end
end
