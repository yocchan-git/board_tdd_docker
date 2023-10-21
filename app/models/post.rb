class Post < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: {maximum: 40}
  validates :content, presence: true, length: {maximum: 250}
end
