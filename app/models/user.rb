class User < ApplicationRecord
  has_many :activitys, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: 6}

  enum role: [:user, :admin]

  has_secure_password

  before_save {self.email = email.downcase}

  scope :search, ->keyword { where "name LIKE ?", "%#{keyword}%" }

  def is_user? user
    self == user
  end

  def feed
    Activity.where("user_id IN (?) OR user_id = ?", following_ids, id)
  end

  def follow other_user
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow other_user
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following? other_user
    following.include?(other_user)
  end

  def create_activity action_type, target_id
    self.activitys.build(user_id: self.id, target_id: target_id,
      action_type: action_type).save
  end
end
