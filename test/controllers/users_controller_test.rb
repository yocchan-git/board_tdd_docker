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
