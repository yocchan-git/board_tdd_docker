require "test_helper"

# テストユーザーを作っておく
class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "よっちゃん", email: "fuyu_1201@yahoo.ne.jp", password: "password")
  end
end

# ユーザーの名前に関するテスト
class UserNameTest < UserTest
  test "名前は空欄にならないようにする" do
    @user.name = " " * 6
    assert_not @user.valid?
  end

  test "名前は50文字以内にする" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
end

# ユーザーのメアドに関するテスト
class UserEmailTest < UserTest
  test "メアドは空欄にならないようにする" do
    @user.email = " " * 6
    assert_not @user.valid?
  end

  test "メアドは250文字以内にする" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "メアドは大文字も小文字にする" do
    upcase_email = "FUyu_1201@YaHOO.Ne.JP"
    @user.email = upcase_email
    @user.save
    assert @user.reload.email, upcase_email.downcase
  end

  test "メアドは正規表現にマッチように（OKなパターン）" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?
    end
  end

  test "メアドは正規表現にマッチように（NGなパターン）" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                         foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?
    end
  end
end

class UserPasswordTest < UserTest
  test "パスワードは空じゃないようにする" do
    @user.password = " " * 6
    assert_not @user.valid?
  end

  test "パスワードは6文字以上にする" do
    @user.password = "a" * 5
    assert_not @user.valid?
  end
end
