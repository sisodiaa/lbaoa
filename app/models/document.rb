class Document < ApplicationRecord
  belongs_to :documentable, polymorphic: true

  has_one_attached :attachment

  validates :annotation, length: { maximum: 50 }
  validate :presence_of_attachment
  validate :size_of_attachment, if: :attached?
  validate :type_of_attachment, if: :attached?

  delegate :attached?, to: :attachment

  def presence_of_attachment
    errors.add(:attachment, "can't be absent") unless attached?
  end

  def size_of_attachment
    errors.add(:attachment, 'is bigger than 5 MB') unless content_size_allowed?
  end

  def type_of_attachment
    errors.add(:attachment, 'content type is not supported') unless content_type_acceptable?
  end

  def content_size_allowed?
    attachment.byte_size <= 5.megabytes
  end

  def content_type_acceptable?
    acceptable_types = ['image/jpeg', 'image/png', 'application/pdf']
    acceptable_types.include?(attachment.content_type)
  end
end
