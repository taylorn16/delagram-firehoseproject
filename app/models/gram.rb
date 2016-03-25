class Gram < ActiveRecord::Base

  belongs_to :user

  validates :message, presence: true
  validates :photo, presence: true

  mount_uploader :photo, PhotoUploader
end
