require "test_helper"

class PostsShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:inactive)
    @post = posts(:post_one)
  end
  test "投稿詳細ページへアクセスできるか" do
    log_in_as @user
    get post_path(@post)
    assert_response :success
  end
end

# ログインしているユーザーの投稿かによってリンクの表示をテストする
class PostShowLinkTest < PostsShowTest
  test "ログインユーザーの投稿の時は「編集+削除」のリンクがある" do
    log_in_as @user
    get post_path(@post)
    assert_select "a[href=?]", edit_post_path(@post)
    assert_select "a[href=?]", "/posts/#{@post.id}"
  end

  test "ログインユーザーの投稿じゃないならリンクは表示されない" do
    log_in_as @other_user
    get post_path(@post)
    assert_select "a[href=?]", edit_post_path(@post), count: 0
    assert_select "a[href=?]", "/posts/#{@post.id}", count: 0
  end
end
