require "test_helper"

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "ユーザー情報を表示する" do
    log_in_as @user
    get "/users/#{@user.id}"
    assert_select "h3", @user.name
    assert_select "p", @user.email
  end

  test "ログインしている本人の詳細ページなら編集リンクもある" do
    log_in_as @user
    get "/users/#{@user.id}"
    assert_select "a[href=?]", "/users/#{@user.id}/edit"
  end
end
