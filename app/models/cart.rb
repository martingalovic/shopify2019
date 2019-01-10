class Cart < ApplicationRecord
  TOKEN_LENGTH = 32

  # Relationships
  has_many :items, class_name: "CartItem", dependent: :destroy

  # Scopes
  scope :not_completed, -> { where('completed_at IS NULL') }

  # Validation
  validates :token, presence: true, length: { is: TOKEN_LENGTH }

  # Callbacks
  after_save :update_inventory, if: :is_completed?

  # Adds products to cart
  # @param [Product] product
  # @return [CartItem] created or updated CartItem
  def add_product(product)
    raise Error::CartItem::ProductTypeError unless product.is_a?(Product)

    items.create({:product_id => product.id})
  end

  # Checks whether cart is completed
  # @return [Boolean]
  def is_completed?
    !completed_at.nil?
  end

  # Marks cart as completed
  # @param [nil|Time] at - When was the cart completed, default: Time.now
  # @return [self]
  def complete(at = nil)
    update(completed_at: at || Time.now)
  end

  private
    # Updates inventory of each products in cart
    # @return [self]
    def update_inventory
      products_ids = items.distinct(:product_id).pluck(:product_id)
      abort products_ids.to_json
      Product.where('id', items.pluck('product_id')).update({inventory_count: 'inventory_count - 1'})
      self
    end

end
