require "test_helper"

class LikesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @post = posts(:post_one)
    @like = likes(:like_one)
  end

  def login_check
    assert_not flash.empty?
    assert_response :redirect
    assert_redirected_to login_path
  end
end

# いいね追加機能のテスト
class LikesCreateControllerTest < LikesControllerTest
  test "ログインしていないといいねはできない" do
    post "/likes/#{@post.id}", params: { user_id: 1}
    login_check
  end

  test "いいねの追加に成功する" do
    log_in_as @user
    post "/likes/#{@post.id}"
    assert_redirected_to posts_path
  end

  test "DBにいいねのレコードが追加されているかのテスト" do
    log_in_as @user
    assert_difference 'Like.count', +1 do
      post "/likes/#{@post.id}"
    end
  end
end

# いいね削除機能のテスト
class LikesDestroyControllerTest < LikesControllerTest
  def setup
    super
    @destoy_like = Like.create(user: @user, post: @post)
  end
  test "ログインしていないといいねを削除できない" do
    delete "/likes/#{@post.id}", params: { user_id: 1}
    login_check
  end

  test "いいねの削除に成功する" do
    log_in_as @user
    delete "/likes/#{@destoy_like.id}"
    assert_redirected_to posts_path
  end

  test "DBにいいねのレコードが削除されているかのテスト" do
    log_in_as @user
    assert_difference 'Like.count', -1 do
      delete "/likes/#{@destoy_like.id}"
    end
  end
end