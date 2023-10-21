require "test_helper"

# titleタグの表示が正しいかを検証する
class HeadTitleTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "ページの内容を「内容 | 掲示板アプリ」とかく" do
    get "/users/new"
    assert_select 'title', "サインアップ | 掲示板アプリ"
  end

  test "ページの詳細がない場合（例:TOPページ）は「掲示板アプリ」とだけ返す" do
    log_in_as @user
    get posts_path
    assert_select "title", "掲示板アプリ"
  end
end
