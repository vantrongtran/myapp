class Lesson < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :results, dependent: :destroy

  validates :user, presence: true
  validates :category, presence: true

  before_create :assign_word
  accepts_nested_attributes_for :results,
    reject_if: proc {|attributes| attributes[:answer_id].blank?},
    allow_destroy: true

  private
  def assign_word
    if self.category.words.size >= Settings.words_lesson
      self.category.words.random_words.limit(Settings.words_lesson)
        .each do |word|
          self.results.build word_id: word.id
        end
    else
      raise ActiveRecord::Rollback
      errors.add :answers, I18n.t("answer_must_more")
    end
  end
end
