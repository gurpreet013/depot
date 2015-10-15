class AddColumnsToProduct < ActiveRecord::Migration
  def change
    add_column :Products, :enabled, :boolean
    add_column :Products, :line_items_count, :integer, default: 0, null: false
    add_column :Products, :discount_price, :decimal
    add_column :Products, :permalink, :string
    change_column :Products,:enabled, :boolean, default: true
  end
end
