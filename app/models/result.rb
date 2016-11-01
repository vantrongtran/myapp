class Result < ApplicationRecord
  belongs_to :answer
  belongs_to :word
  belongs_to :lesson

  scope :correct_anwsers, -> do
    joins(:answer).where("answers.is_correct = ?", true)
  end
end

