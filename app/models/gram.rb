class Gram < ActiveRecord::Base

  belongs_to :user
  has_many :comments

  validates :message, presence: true
  validates :photo, presence: true

  mount_uploader :photo, PhotoUploader
end
