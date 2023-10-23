class User < ApplicationRecord
    mount_uploader :image, ImageUploader
    has_many :posts, dependent:   :destroy
    has_many :comments, dependent:   :destroy
    has_many :likes, dependent:   :destroy
    has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
    has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
    has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships, source: :follower
    
    before_save { self.email = email.downcase }
    validates :name, presence: true, length: {maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, length: {maximum: 250},
                                      format: { with: VALID_EMAIL_REGEX }
    has_secure_password
    validates :password, presence: true, length: {minimum: 6}, allow_nil: true

    # 渡された文字列のハッシュ値を返す
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    # フォローする
    def follow(other_user)
        following << other_user unless self == other_user
    end

    # フォローを解除する
    def unfollow(other_user)
        following.delete(other_user)
    end

    # フォローしているかの論理値を返す
    def following?(other_user)
        following.include?(other_user)
    end

    def self.ransackable_attributes(auth_object = nil)
        ["created_at", "email", "id", "name", "password_digest", "updated_at"]
    end
end
