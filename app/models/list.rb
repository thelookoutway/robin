class List < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_and_belongs_to_many :users

  before_validation :generate_webhook_token, on: :create

  validates :name, presence: true
  validates :slack_channel_id, presence: true
  validates :webhook_token, presence: true, uniqueness: true

  def ordered_users
    list_users = users.alphabetically.to_a
    latest_task_user = tasks.not_unassigned.not_archived.newest.first&.user
    count = list_users.index(latest_task_user)&.succ || 0
    list_users.rotate(count)
  end

  private

  def generate_webhook_token
    return if webhook_token.present?

    self.webhook_token = loop do
      webhook_token = SecureRandom.hex(64)
      break webhook_token unless List.where(webhook_token: webhook_token).exists?
    end
  end
end
