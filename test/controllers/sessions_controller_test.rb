require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
    def setup
        @user = users(:michael)
    end
end

# ログイン関連のコントローラテスト
class LoginTest < SessionsControllerTest

  test "ログイン画面にアクセスする" do
    get "/login"
    assert_response :success
  end

  test "正しい認証情報でログインする" do
    post "/login", params:{email: @user.email, password: 'password'}
    assert_not flash.empty?
    assert_redirected_to posts_path
    assert_equal session[:user_id], @user.id
  end

  test "間違った認証情報でログインする" do
    post "/login", params:{email: @user.email, password: 'foobar'}
    assert_not flash.empty?
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
  end
end

# ログアウト関連のコントローラテスト
class LogoutTest < SessionsControllerTest
  test "logoutに通信できるかどうか？" do
    delete "/logout"
    assert_response :see_other
  end

  test "logoutの処理が正しく行われているのか？" do
    log_in_as(@user)
    delete "/logout"
    assert_redirected_to login_path
    follow_redirect!
    assert_not flash.empty? 
    assert session[:user_id].nil?
    assert @current_user.nil?
  end
end
