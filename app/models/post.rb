class Post < ApplicationRecord
  belongs_to :category
  has_many :comments, dependent: :destroy
  has_many :photos, dependent: :destroy

  def featured?
    featured
  end

  # Define a scope to get all featured posts
  scope :featured, -> { where(featured: true) }
end
