class Task < ApplicationRecord
  belongs_to :list
  belongs_to :user, optional: true
  belongs_to :instigator, class_name: "User", optional: true

  enum status: [:accepted, :reassigned, :archived]

  validates :description, presence: true

  scope :newest, -> { order(created_at: :desc) }
  scope :not_archived, -> { where.not(status: :archived).or(Task.where(status: nil)) }
  scope :exclude_unassigned, -> { where.not(status: nil).or(Task.where.not(user_id: nil)) }

  delegate :name, :webhook_token, to: :list, prefix: true
  delegate :slack_channel_id, to: :list

  def assign_user
    update(user: list.ordered_users.detect { |user| acceptable_candidate?(user) })
    user
  end

  def slack_user_id
    user&.slack_id
  end

  private

  def acceptable_candidate?(user)
    !user.excluded? &&
      !(list.instigator_excluded? && user == instigator)
  end
end
