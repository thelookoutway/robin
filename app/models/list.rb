class List < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_and_belongs_to_many :users

  validates :name, presence: true
  validates :slack_channel_id, presence: true

  before_create :generate_webhook_token

  def ordered_users
    list_users = users.alphabetically.to_a
    latest_task_user = tasks.not_archived.newest.first&.user
    count = list_users.index(latest_task_user)&.succ || 0
    list_users.rotate(count)
  end

  private

  def generate_webhook_token
    loop do
      new_webhook_token = SecureRandom.hex(64)
      if List.where(webhook_token: new_webhook_token).empty?
        self.webhook_token = new_webhook_token
        break
      end
    end
  end
end
