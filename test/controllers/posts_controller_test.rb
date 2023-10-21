require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:inactive)
    @post = posts(:post_one)
  end
end 

# 新規投稿のcreateメソッドをテストする
class PostsCreateTest < PostsControllerTest
  test "登録できるのはログインしているユーザーだけ" do
    post "/posts", params: { post: { title: @post.title, content: @post.content}}
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "登録に成功した時のテスト" do
    log_in_as @user
    post "/posts", params: { post: { title: @post.title, content: @post.content}}
    assert_not flash.empty?
    assert_redirected_to posts_path
  end

  test "登録に失敗した時のテスト" do
    log_in_as @user
    post "/posts", params: { post: { title: "", content: @post.content}}
    assert_response :unprocessable_entity
    assert_template "posts/new"
  end

  test "データベースに登録されているかチェックする" do
    log_in_as @user
    assert_difference 'Post.count', +1 do
      post "/posts", params: { post: { title: @post.title, content: @post.content}}
    end
  end
end

# 投稿のupdateメソッドをテストする
class PostsUpdateTest < PostsControllerTest
  test "updateメソッドはログインしているユーザーだけ" do
    patch "/posts/#{@post.id}", params: { post: { title: "更新後のタイトル", content: @post.content}}
    assert_redirected_to login_path
  end

  test "updateメソッドで編集できるのは投稿した本人だけ" do
    log_in_as @other_user
    patch "/posts/#{@post.id}", params: { post: { title: "更新後のタイトル", content: @post.content}}
    assert_not flash.nil?
    assert_redirected_to posts_path
  end

  test "正しく更新処理ができた時のテスト" do
    log_in_as @user
    patch "/posts/#{@post.id}", params: { post: { title: "更新後のタイトル", content: @post.content}}
    assert_not flash.empty?
    assert_redirected_to post_path(@post)
    assert "更新後のタイトル", @post.reload.title
  end

  test "更新処理できなかった時のテスト" do
    log_in_as @user
    patch "/posts/#{@post.id}", params: { post: { title: "", content: @post.content}}
    assert_response :unprocessable_entity
    assert_template "posts/edit"
  end
end

# 投稿のdestroyメソッドをテストする
class PostsDestroyTest < PostsControllerTest
  test "destroyメソッドはログインしているユーザーだけ" do
    delete "/posts/#{@post.id}"
    assert_redirected_to login_path
  end

  test "destroyメソッドで編集できるのは投稿した本人だけ" do
    log_in_as @other_user
    delete "/posts/#{@post.id}"
    assert_not flash.nil?
    assert_redirected_to posts_path
  end

  test "正しく削除されるかをテスト" do
    log_in_as @user
    delete "/posts/#{@post.id}"
    assert_not flash.empty?
    assert_response :see_other
    assert_redirected_to posts_path
  end

  test "データベースから削除されているか数を調べる" do
    log_in_as @user
    assert_difference 'Post.count', -1 do
      delete "/posts/#{@post.id}"
    end
  end
end