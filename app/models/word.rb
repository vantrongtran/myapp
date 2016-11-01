class Word < ApplicationRecord
  belongs_to :category
  has_many :answers, dependent: :destroy
  has_many :results, dependent: :destroy

  validates :content, presence: true, length: {maximum: 100}
  validate :validate_answers

  accepts_nested_attributes_for :answers, allow_destroy: true

  scope :search, ->keyword {where "content LIKE ?", "%#{keyword}%"}

  scope :random_words, -> {order("RANDOM()")}

  QUERY_LEARNED = "content like :search and id in (select word_id
    FROM results r INNER JOIN lessons l
    ON r.lesson_id = l.id AND l.user_id = :user_id)"
  QUERY_NOT_LEARNED = "content like :search and id not in (select word_id
    FROM results r INNER JOIN lessons l
    ON r.lesson_id = l.id AND l.user_id = :user_id)"

  scope :learned, -> user_id, search{
    where QUERY_LEARNED, user_id: user_id, search: "%#{search}%"
  }
  scope :not_learned, -> user_id, search{
    where QUERY_NOT_LEARNED, user_id: user_id, search: "%#{search}%"
  }
  scope :filter_category, -> category_id{
    where "category_id = ?", "#{category_id}"
  }
  scope :show_all, -> user_id, keyword{
    where("content LIKE ? ", "%#{keyword}%")
  }
  def validate_answers
    if answers.size < Settings.minimum_answer
      errors.add :answers, I18n.t("answer_must_more_one")
    end
    if answers.reject{|answer| !answer.is_correct?}.count == 0
      errors.add :answers, I18n.t("word_must_has_correct_answer")
    end
  end
end
