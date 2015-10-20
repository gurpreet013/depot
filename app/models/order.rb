class Order < ActiveRecord::Base
  PAYMENT_TYPES = [ "Check", "Credit card", "Purchase order" ]
  has_many :line_items, dependent: :destroy
  belongs_to :user
  validates :name, :address, :email, presence: true, uniqueness: :true
  validates :pay_type, inclusion: PAYMENT_TYPES
  scope :by_date, ->(from=Time.current.midnight, to=Time.current.midnight+1.day){ where("created_at between ? and ?", from,to)}
  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      # item.cart_id = nil
      line_items << item
    end
  end

end
