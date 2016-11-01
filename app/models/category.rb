class Category < ApplicationRecord
  has_many :lessons
  has_many :words, dependent: :destroy

  validates :name, presence: true
  validates :description, length: {maximum: 200}

  def verify_destroy?
    !self.lessons.any?
  end

  scope :search, ->keyword { where "name LIKE ?", "%#{keyword}%" }

end
