class LineItem < ActiveRecord::Base
  belongs_to :product, counter_cache: true
  belongs_to :cart
  belongs_to :order

  validates :product_id, uniqueness: {scope: :cart_id}


  def total_price
    product.price * quantity
  end

end
