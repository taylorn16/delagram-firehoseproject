class Comment < ActiveRecord::Base

  belongs_to :user
  belongs_to :gram

  validates :text, presence: true, length: {minimum: 2, maximum: 140}

end
