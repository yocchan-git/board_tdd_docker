require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "ユーザー一覧表示されるかのチェック" do
    log_in_as @user
    get "/users"
    User.all.each do |user|
      assert_select "a", user.name
    end
  end

end
