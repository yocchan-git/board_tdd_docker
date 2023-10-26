class Post < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: {maximum: 40}
  validates :content, presence: true, length: {maximum: 250}

  # 以下の2つのメソッドがないと検索ができなくなる
  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "title", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["comments", "likes", "user"]
  end
end
