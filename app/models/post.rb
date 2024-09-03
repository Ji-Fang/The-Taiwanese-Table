class Post < ApplicationRecord
  belongs_to :category

  def featured?
    featured
  end

  # Define a scope to get all featured posts
  scope :featured, -> { where(featured: true) }
end
