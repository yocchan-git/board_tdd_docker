require "test_helper"

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @user1 = users(:michael)
    @user2 = users(:inactive)
    @follow = Relationship.new(follower_id: @user1.id,
                               followed_id: @user2.id)
  end

  test "まずは動作テストをする" do
    assert @follow.valid?
  end

  test "follower_idが空ならバリデーションエラー" do
    @follow.follower_id = nil
    assert_not @follow.valid?
  end

  test "followed_idが空ならバリデーションエラー" do
    @follow.followed_id = nil
    assert_not @follow.valid?
  end
end
