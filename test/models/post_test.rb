require "test_helper"

class PostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @post = @user.posts.build(title: "サンプルポスト",content: "テストテストテスト")
  end
end

# タイトルに関してのテスト
class PostTitleTest < PostTest
  test "タイトルは空じゃないようにする" do
    @post.title = " " * 6
    assert_not @post.valid?
  end

  test "タイトルは40文字以内にする" do
    @post.title = "a" * 41
    assert_not @post.valid?
  end
end

# contentに関してのテスト
class PostContentTest < PostTest
  test "内容は空じゃないようにする" do
    @post.content = " " * 6
    assert_not @post.valid?
  end

  test "内容は250文字以内にしてもらう" do
    @post.content = "a" * 251
    assert_not @post.valid?
  end
end