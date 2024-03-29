class Event < ApplicationRecord

  mount_uploader :photo, PhotoUploader
  belongs_to :user
  has_many :participations
  monetize :price_cents
end
