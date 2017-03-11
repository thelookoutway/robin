class List < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_and_belongs_to_many :users

  validates :name, presence: true
  validates :slack_channel_id, presence: true

  def next_user
    all_users = users.alphabetically
    all_tasks = tasks.not_archived.newest
    if all_tasks.empty?
      all_users.first
    else
      index = all_users.index(all_tasks.first.user) || -1
      all_users[index + 1] || all_users.first
    end
  end
end
