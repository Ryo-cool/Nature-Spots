require "validator/email_validator"

class User < ApplicationRecord
  include UserAuth::Tokenizable

  # アソシエーション
  has_many :likes, dependent: :destroy
  has_many :liked_reviews, through: :likes, source: :review
  has_many :reviews, dependent: :destroy
  has_many :liked_spots, through: :likes, source: :spot
  # フォロー機能関係
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationships, source: :user

  before_validation :downcase_email

  # フォロー機能関係メソッド
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

  # gem bcrypt
  has_secure_password

  # validates
  validates :name, presence: true,
                    length: { maximum: 30, allow_blank: true }
                    VALID_PASSWORD_REGEX = /\A[\w\-]+\z/
  validates :password, presence: true,
                        length: { minimum: 8 },
                        format: {
                          with: VALID_PASSWORD_REGEX,
                          message: :invalid_password 
                        },
                        allow_blank: true
  ## methods
  # class method  ###########################
  class << self
    # emailからアクティブなユーザーを返す
    def find_activated(email)
      find_by(email: email, activated: true)
    end
  end
  # class method end #########################

  # 自分以外の同じemailのアクティブなユーザーがいる場合にtrueを返す
  def email_activated?
    users = User.where.not(id: id)
    users.find_activated(email).present?
  end

  # 共通のJSONレスポンス。カラムを増やした場合は配列に追加する。
  def my_json
    as_json(only: [:id, :name, :email, :created_at])
  end
  
  private

    # email小文字化
    def downcase_email
      self.email.downcase! if email
    end
end
