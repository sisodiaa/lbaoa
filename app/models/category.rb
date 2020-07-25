class Category < ApplicationRecord
  has_many :posts, dependent: :nullify, inverse_of: :category

  before_save { title.downcase! }

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 1024 }
end
