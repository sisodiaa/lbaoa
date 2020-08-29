class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable, :confirmable,
         :recoverable, :rememberable, :validatable, :lockable, :timeoutable

  enum status: {
    pending: 0,
    approved: 1,
    flagged: 2,
    archived: 3,
    bogus: 4
  }

  scope :confirmed, -> { where('confirmed_at IS NOT NULL') }

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : inactive_message_based_on_status
  end

  private

  def inactive_message_based_on_status
    return :unconfirmed unless confirmed?
    return :not_approved if pending?
    return :account_flagged if flagged?
    return :account_archived if archived?
    return :bogus_account if bogus?
  end
end
