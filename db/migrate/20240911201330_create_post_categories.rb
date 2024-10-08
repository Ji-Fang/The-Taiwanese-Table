class CreatePostCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :post_categories do |t|
      t.references :post, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
