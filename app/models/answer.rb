class Answer < ApplicationRecord
  has_many :results, dependent: :destroy
  belongs_to :word, optional: true
  validates :content, presence: true
end
