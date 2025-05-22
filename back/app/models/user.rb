require "validator/email_validator"

class User < ApplicationRecord
  include UserAuth::Tokenizable

  # アソシエーション
  has_many :likes, dependent: :destroy
  has_many :liked_reviews, through: :likes, source: :review
  has_many :reviews, dependent: :destroy
  has_many :liked_spots, through: :likes, source: :spot # Spots liked via reviews
  has_many :favorites, dependent: :destroy
  has_many :favorite_spots, through: :favorites, source: :spot # Actual spots favorited by the user
  # フォロー機能関係
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationships, source: :user
  # 画像アップロード
  mount_uploader :image, ImageUploader

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
                  length: { minimum: 2, maximum: 30 },
                  format: { with: /\A[ぁ-んァ-ヶー一-龠]+\z/, message: "は日本語で入力してください" }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                   length: { maximum: 255 },
                   format: { with: VALID_EMAIL_REGEX },
                   uniqueness: { case_sensitive: false }

  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)[a-zA-Z\d]{8,}\z/
  validates :password, presence: true,
                      length: { minimum: 8 },
                      format: {
                        with: VALID_PASSWORD_REGEX,
                        message: "は8文字以上の半角英数字で、大文字・小文字・数字を含める必要があります"
                      },
                      allow_blank: true

  validates :introduction, length: { maximum: 500 }

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
    as_json(only: [:id, :name, :email, :image, :introduction, :created_at])
  end
  
  private

    # email小文字化
    def downcase_email
      self.email.downcase! if email
    end
end
