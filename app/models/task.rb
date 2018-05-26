class Task < ApplicationRecord
  belongs_to :list
  belongs_to :user, optional: true
  belongs_to :instigator, class_name: "User", optional: true

  enum status: [:accepted, :reassigned, :archived, :unassigned, :assigned]

  validates :description, presence: true
  validates :status, presence: true
  validates :user, absence: true, if: :unassigned?
  validates :user, presence: true, unless: :unassigned?

  scope :newest, -> { order(created_at: :desc) }
  scope :not_archived, -> { where.not(status: :archived) }
  scope :not_unassigned, -> { where.not(status: :unassigned) }

  delegate :name, :webhook_token, to: :list, prefix: true
  delegate :slack_channel_id, to: :list

  def assign_user
    new_user = list.ordered_users.detect { |user| acceptable_candidate?(user) }

    if new_user
      update(
        status: :assigned,
        user: new_user,
      )
    end

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
