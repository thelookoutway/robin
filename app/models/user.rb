class User < ApplicationRecord
  has_and_belongs_to_many :lists
  has_many :tasks

  validates :slack_id, presence: true
  validates :slack_name, presence: true

  scope :alphabetically, -> { order(slack_name: :asc) }
end
