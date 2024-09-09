require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one) # Make sure to define this fixture or create a post object
    @comment = comments(:one) # Define this fixture or create a comment object
  end

  test "should create comment" do
    post post_comments_url(@post), params: { comment: { body: "Test comment" } }
    assert_response :success
  end

  test "should destroy comment" do
    delete post_comment_url(@post, @comment)
    assert_response :success
  end
end
