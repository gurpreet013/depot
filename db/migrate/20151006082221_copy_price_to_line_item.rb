class CopyPriceToLineItem < ActiveRecord::Migration

  def up
    LineItem.all.each do |item|
      item.price = Product.find_by(id: item.product_id).price
      item.save
    end
  end

end
