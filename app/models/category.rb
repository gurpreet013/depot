class Category < ActiveRecord::Base
  has_many :products
  belongs_to :parent, class_name: :Category
  has_many :sub_categories, class_name: :Category, foreign_key: :parent_id
  validates :title, presence: true
  validates :title, uniqueness:{ scope: [:parent_id, :title] }, if: "!title.nil?"
  validate :one_level_nesting
  before_destroy :valid?


  def valid?
    if products.size !=0
      return false
    end
  end

  def one_level_nesting
    if self.class.exists? parent && self.class.exists?(parent.parent)
      raise 'Sub Category cannot have their own sub category'
    end
  end

end
