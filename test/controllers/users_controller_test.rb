require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:inactive)
  end
end

# サインアップ関連のログインテスト
class SignupTest < UsersControllerTest
  test "get通信の/users/newの動作確認" do
    get users_new_path
    assert_response :success
  end

  test "バリデーションエラーはrenderで/users/newに戻る" do
    post "/users/new", params: { name: "", email: "invalid", password: "foo"}
    # ユーザー登録ページが再表示されることを確認
    assert_template "users/new"
  end

  test "正しい値を入力したらフラッシュとリダイレクトが正しくできてる" do
    post "/users/new", params: { name: "よっちゃん", email: "fuyu_1201@yahoo.ne.jp", password: "password"}
    assert_not flash.empty?
    assert_redirected_to posts_path
  end
end

class UsersShowControllerTest < UsersControllerTest
  test "ユーザー情報が見れるのはログインしているユーザーのみ" do
    get "/users/#{@user.id}"
    assert_redirected_to login_path
  end

  test "ログインしていたらユーザー詳細ページにアクセスできる" do
    log_in_as @user
    get "/users/#{@user.id}"
    assert_response :success
  end
end

class UsersEditControllerTest < UsersControllerTest
  test "ログインしていないとリダイレクトする" do
    get "/users/#{@user.id}/edit"
    assert_redirected_to login_path
  end

  test "ユーザー情報を編集できるのはログインしているユーザーのみ" do
    log_in_as @user
    get "/users/#{@user.id}/edit"
    assert_response :success
  end
end

class UsersUpdateControllerTest < UsersControllerTest

  test "ログインしていないとリダイレクトする" do
    post "/users/#{@user.id}", params: { name: "よっちゃん", email: "fuyu_1201@yahoo.ne.jp", password: "password"}
    assert_redirected_to login_path
  end

  test "アップデート成功の時の動き" do
    log_in_as @user
    post "/users/#{@user.id}", params: { name: "よっちゃん", email: "fuyu_1201@yahoo.ne.jp"}
    assert_not flash.empty?
    assert_redirected_to "/users/#{@user.id}"
  end

  test "アップデート失敗の時の動き" do
    log_in_as @user
    post "/users/#{@user.id}", params: { name: "", email: ""}
    assert_response :unprocessable_entity
    assert_template "users/edit"
  end
end