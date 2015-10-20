class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title
      t.belongs_to(:parent, index:true, class_name: :Category)
      t.timestamps null: false
    end
    # add_index :categories, :parent_id, refrences: :categories
  end
end
