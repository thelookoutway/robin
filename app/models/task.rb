class Task < ApplicationRecord
  belongs_to :list
  belongs_to :user, optional: true
  belongs_to :instigator, class_name: "User", optional: true

  enum status: [:accepted, :reassigned, :archived]

  validates :description, presence: true

  scope :newest, -> { order(created_at: :desc) }
  scope :not_archived, -> { where.not(status: :archived).or(Task.where(status: nil)) }

  def assign_user
    update(user: list.ordered_users.detect { |user| acceptable_candidate?(user) })
    user
  end

  def list_name
    list.name
  end

  def list_webhook_token
    list.webhook_token
  end

  def slack_channel_id
    list.slack_channel_id
  end

  def slack_user_id
    user.slack_id
  end

  private

  def acceptable_candidate?(candidate)
    !candidate.excluded? &&
      !(list.instigator_excluded? && candidate == instigator)
  end
end
