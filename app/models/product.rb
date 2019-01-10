class Product < ApplicationRecord
  has_many :cart_items

  scope :available, -> { where('inventory_count > 0') }

  # @param [Integer] by | Amount of which the inventory will be decreased
  # @return [self]
  def decrease_inventory(by = 1)
    decrement!(:inventory_count, by.abs)
  end

  # @param [Integer] by | Amount of which the inventory will be increased
  # @return [self]
  def increase_inventory(by = 1)
    increment!(:inventory_count, by.abs)
  end
end
