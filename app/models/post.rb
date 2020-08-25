class Post < ApplicationRecord
  include AASM

  belongs_to :category, inverse_of: :posts

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  has_many :documents, as: :documentable, dependent: :destroy

  has_rich_text :content

  enum publication_state: {
    draft: 0,
    finished: 1
  }

  enum visibility_state: {
    members: 0,
    visitors: 1
  }

  validates :title, presence: true, length: { maximum: 256 }
  validates :content, presence: true
  validate :number_of_tags

  aasm(
    :publication,
    column: :publication_state,
    enum: true,
    no_direct_assignment: true
  ) do
    state :draft, initial: true
    state :finished

    event :publish do
      transitions from: :draft, to: :finished
    end
  end

  aasm(
    :visibility,
    column: :visibility_state,
    enum: true,
    no_direct_assignment: true
  ) do
    state :members, initial: true
    state :visitors

    # Casting can only be performed on a published post
    event :broadcast do
      transitions from: :members, to: :visitors, if: :publication_finished?
    end

    event :narrowcast do
      transitions from: :visitors, to: :members, if: :publication_finished?
    end
  end

  def publication_finished?
    finished?
  end

  def tag_list
    tags.pluck(:name).join(', ')
  end

  def tag_list=(tags_string)
    self.tags = tags_string
                .split(',')
                .collect(&:strip)
                .reject(&:empty?)
                .uniq
                .collect { |name| Tag.find_or_create_by(name: name) }
  end

  def number_of_tags
    errors.add(:tags, 'should not be more than 5') if tags.length > 5
  end

  # Query methods

  def self.published_between(start_date, end_date)
    where(published_at: start_date...end_date)
  end

  def self.with_category(category)
    joins(:category).where(categories: { title: category })
  end

  def self.with_tags(tags)
    includes(:tags).where(tags: { name: tags })
  end
end
