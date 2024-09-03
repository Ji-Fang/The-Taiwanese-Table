class PostsController < ApplicationController
  def index
    @featured_posts = Post.where(featured: true).limit(3)
    @categories = Category.all
    @popular_posts = Post.order(views_count: :desc).limit(4)
  end

  def show
    @post = Post.find(params[:id])
    @post.increment!(:views_count) # Increment view count for each show
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :category_id, :youtube_video, :featured, :views_count, images: [])
  end
end
