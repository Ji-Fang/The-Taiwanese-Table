class Post < ApplicationRecord
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :comments, dependent: :destroy
  has_many :photos, dependent: :destroy

  def featured?
    featured
  end

  # Define a scope to get all featured posts
  scope :featured, -> { where(featured: true) }
end
