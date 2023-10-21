require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:inactive)
    @post = posts(:post_one)
    @comment = comments(:comment_one)
  end

  def login_check
    assert_not flash.empty?
    assert_response :redirect
    assert_redirected_to login_path
  end
end

# 新規登録フォームについてのテスト
class CommentsNewControllerTest < CommentsControllerTest
  test "新規コメントフォームにhidden属性で数字が入っているフォームがあるか調べる" do
    log_in_as @user
    get "/comments/#{@post.id}/new"
    assert_select "input[type=hidden][value=#{@user.id}]", count: 1
    assert_select "input[type=hidden][value=#{@post.id}]", count: 1
  end

  test "新規コメントの作成ができるのはログインしているユーザーだけ" do
    get "/comments/#{@post.id}/new"
    login_check
  end
end

# 新規登録処理についてのテスト
class CommentsCreateControllerTest < CommentsControllerTest
  test "正しい情報を入力した時のcreate" do
    log_in_as @user
    post "/comments/new", params: {user_id:@user.id, post_id: @post.id, comment: @comment.comment}
    assert_not flash.empty?
    assert_redirected_to posts_path
  end

  test "間違った情報を入力した時のcreate" do
    log_in_as @user
    post "/comments/new", params: {user_id: "", post_id: "", comment: ""}
    assert_response :unprocessable_entity
    assert_template "comments/new"
  end

  test "データベースの数が増えているかをテストする" do
    log_in_as @user
    assert_difference 'Comment.count', +1 do
      post "/comments/new", params: {user_id:@user.id, post_id: @post.id, comment: @comment.comment}
    end
  end

  test "createできるのはログインしているユーザーだけ" do
    post "/comments/new", params: {user_id:@user.id, post_id: @post.id, comment: @comment.comment}
    login_check
  end
end

# コメント編集処理についてのテスト
class CommentsUpdateControllerTest < CommentsControllerTest

  test "正しい情報を入力して編集する" do
    log_in_as @user
    # ユーザーIDとポストIDは変更しない
    post "/comments/#{@comment.id}/update", params: {comment: "昨日は楽しかったね。"}
    assert_not flash.empty?
    assert_redirected_to posts_path
  end

  # ERROR:コメントアウトを外すとエラーになる
  test "誤った情報はeditページへrenderする" do
    log_in_as @user
    # @commentを使うとエラーになるので新しく作成
    comment = Comment.create(user: @user, post: @post, comment: "テストコメント")
    post "/comments/#{comment.id}/update", params: {comment: " "}
    assert_template "comments/edit"
  end

  test "コメントを編集できるのはログインしている人だけ" do
    post "/comments/#{@comment.id}/update", params: {comment: "昨日は楽しかったね。"}
    login_check
  end

  test "コメントを編集できるのはコメントした本人だけ" do
    log_in_as @other_user
    post "/comments/#{@comment.id}/update", params: {comment: "昨日は楽しかったね。"}
    assert_not flash.empty?
    assert_response :redirect
    assert_redirected_to posts_path
  end
end

# コメント削除処理についてのテスト
class CommentsDestroyControllerTest < CommentsControllerTest
  def setup
    super
    # @commentを使うとエラーになるので新しく作成
    @comment_destroy_for_not_bug = Comment.create(user: @user, post: @post, comment: "テストコメント")
  end
  test "コメントの削除処理が成功する" do
    log_in_as @user
    delete "/comments/#{@comment_destroy_for_not_bug.id}"
    assert_not flash.empty?
    assert_response :see_other
    assert_redirected_to posts_path
  end

  test "正しく削除されるか、数を比べる" do
    log_in_as @user
    assert_difference 'Comment.count', -1 do
      delete "/comments/#{@comment_destroy_for_not_bug.id}"
    end
  end

  test "コメントを削除できるのはログインしているユーザーだけ" do
    delete "/comments/#{@comment.id}"
    login_check
  end

  test "コメントの削除できるのはコメントした本人だけ" do
    log_in_as @other_user
    delete "/comments/#{@comment_destroy_for_not_bug.id}"
    assert_not flash.empty?
    assert_response :redirect
    assert_redirected_to posts_path
  end
end