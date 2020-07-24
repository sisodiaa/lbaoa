class Category < ApplicationRecord
  has_many :posts, dependent: :nullify, inverse_of: :category

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 1024 }
end
