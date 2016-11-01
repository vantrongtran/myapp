class Activity < ApplicationRecord
  belongs_to :user
  default_scope ->{order(created_at: :desc)}
  validates :user_id, presence: true
  validates :action_type, presence: true
  validates :target_id, presence: true
  enum action_type: [:create_lesson, :finish_lesson , :follow_user,
    :unfollow_user]
end
