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
    raise Error::Cart::AlreadyCompletedError if is_completed?
    raise Error::CartItem::ProductTypeError unless product.is_a?(Product)

    # We only want one same product in cart at the time
    # We could simple change `where` to `create` and remove `first_or_create`
    #   or we could even add `qty` column to cart_items and use it as a counter
    items.where({:product_id => product.id}).first_or_create
  end

  # Gets total cart sum by current product prices
  # @return [Float] total sum
  def calculate_total
    items.joins(:product).sum("#{Product.table_name}.price").to_f
  end

  # Gets total cart sum based on condition whether cart is completed or not
  # If Cart isn't completed method returns price calculated on current product prices
  #   otherwise method returns value stored in database
  # @return [Float] total sum
  def total
    return calculate_total unless is_completed?

    self[:total].to_f
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
    raise Error::Cart::AlreadyCompletedError if is_completed?

    update({
               completed_at: at || Time.now,
               total: calculate_total
           })
  end

  private
    # Updates inventory of each products in cart
    # @return [self]
    def update_inventory
      products_ids = items.distinct(:product_id).pluck(:product_id)
      Product.where(:id => products_ids).update_all('inventory_count = inventory_count - 1')
      self
    end

end
