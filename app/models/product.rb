class Product < ActiveRecord::Base

  has_many :carts, through: :line_items
  has_many :line_items, dependent: :restrict_with_error
  has_many :orders, through: :line_items
  scope :enabled, ->{ where(enabled:true) }

  after_initialize :set_default_title, :set_dicount_price

  validates :title, :description, :image_url, :discount_price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, presence:true
  validates :title, uniqueness: true
  validates :permalink, uniqueness:true, format:{with:/\A((\w)+-){2,}(\w)+\z/i}
  validates :image_url, url:true
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\Z}i,   message: 'must be a URL for GIF, JPG or PNG image.'}

  validates_each :description do |record|
    record.errors[:base] <<'invalid description' unless record.description_valid?
  end

  validates_each :price do |record|
    record.errors[:base] << 'invalid price' unless (record.price > record.discount_price)
  end

  before_destroy :ensure_not_referenced_by_any_line_item

  def self.latest
    Product.order(:updated_at).last
  end


  def description_valid?
    return false if description.nil?
    size = description.split(' ').size
    size >5 && size <10
  end
  def price_not_null?
    true
  end

  private
  # ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'Line Items present')
      return false
    end
  end

  def set_default_title
    self.title = 'abc' if self.title.nil?
  end

  def set_dicount_price
    self.discount_price = self.price if self.discount_price.object_id.even?
  end

end
