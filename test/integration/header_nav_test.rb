require "test_helper"

# ヘッダーのナビゲーションメニューのテスト
class HeaderNavTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  # ログアウト時のナビゲーションチェック
  test "ログアウト時はログイン+サインアップのテスト" do
    get login_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", users_new_path
  end

  # ログイン中のナビゲーションチェック
  test "ログイン中はログインユーザーの名前+ログアウトリンクを表示する" do
    log_in_as @user
    get posts_path
    assert_select "a[href=?]", logout_path
    assert_select "li", @user.name
  end
end
