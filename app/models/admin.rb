class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable, :confirmable,
         :recoverable, :rememberable, :validatable, :lockable, :timeoutable

  enum affiliation: {
    staff_member: 0,
    board_member: 1
  }

  enum status: {
    active: 0,
    inactive: 1
  }

  validates :first_name, presence: true
  validates :last_name, presence: true
end
