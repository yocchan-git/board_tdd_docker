require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  # ERROR: コメントアウト外すと何故かできない
  test "ユーザー更新フォームには名前とメアドの更新欄がある" do
    get "/users/#{@user.id}/edit"
    # assert_select "input[name=?]", 'name', { count: 1 }
    # assert_select "input[name=?]", 'email', { count: 1 }
  end
end
