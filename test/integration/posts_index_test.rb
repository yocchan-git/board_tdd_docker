require "test_helper"

class PostsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user1 = users(:michael)
    @user2 = users(:inactive)

    @post1 = posts(:post_one)
    @post2 = posts(:post_two)

    @comment = Comment.create(user: @user1, post: @post2, comment: "テストコメント")
  end

  test "投稿のタイトルが詳細ページへのリンクになっているかチェックする" do
    log_in_as(@user1)
    get posts_path
    assert_select "a[href=?]", post_path(@post1)
    assert_select "a[href=?]", post_path(@post2)
  end

  test "投稿した人の名前が表示されているかチェックする" do
    log_in_as(@user1)
    get posts_path
    assert_select "p", @user1.name
    assert_select "p", @user2.name
  end

  test "コメントの「編集+削除」リンクはコメントを書いた本人だけに表示される" do
    log_in_as(@user1)
    get posts_path
    assert_select "a[href=?]", "/comments/#{@comment.id}/edit"
    assert_select "a[href=?]", "/comments/#{@comment.id}"
  end

  test "ログインユーザーのコメント以外はリンクが表示されない" do
    log_in_as(@user2)
    get posts_path
    assert_select "a[href=?]", "/comments/#{@comment.id}/edit", count: 0
    assert_select "a[href=?]", "/comments/#{@comment.id}", count: 0
  end
end
