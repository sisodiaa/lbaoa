class Post < ApplicationRecord
  include AASM

  belongs_to :department, inverse_of: :posts

  has_many :documents, as: :documentable, dependent: :destroy

  enum publication_state: {
    draft: 0,
    finished: 1
  }

  enum visibility_state: {
    members: 0,
    visitors: 1
  }

  validates :title, presence: true, length: { maximum: 256 }

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

    event :broadcast do
      transitions from: :members, to: :visitors, if: :publication_finished?
    end
  end

  def publication_finished?
    finished?
  end
end
