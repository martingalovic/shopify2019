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
  def add_product(product, qty = 1)
    qty = qty.to_i

    raise Error::CartItem::InsufficientProductQty if qty <= 0
    raise Error::ShopifyError.new("product Argument should be instance of Product class") unless product.is_a?(Product)

    item = items.where(:product_id => product.id).first_or_create
    item.increment!(:qty, qty)
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
      cart_items.each(&:decrease_inventory)
      self
    end

end
