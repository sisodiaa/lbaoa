class Tag < ApplicationRecord
  before_save { name.downcase! }

  has_many :taggings, dependent: :destroy
  has_many :posts, through: :taggings

  validates :name, presence: true
end
