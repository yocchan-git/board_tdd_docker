require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @post = posts(:post_two)
    @comment = @post.comments.build(user: @user, comment: "今日もお疲れ様!!")
  end
end

# contentの部分のバリデーションチェック
class CommentCommentTest < CommentTest
  test "そのままでもバリデーションエラーにならない感じ" do
    assert @comment.valid?
  end

  test "空のコメントはできない様にする" do
    @comment.comment = " " * 6
    assert_not @comment.valid?
  end

  test "50文字以上のコメントはできない様にする" do
    @comment.comment = "a" * 51
    assert_not @comment.valid?
  end
end