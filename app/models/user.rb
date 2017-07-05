class User < ApplicationRecord

  has_secure_password

  has_many :auctions, dependent: :destroy
  has_many :bids, dependent: :destroy
  has_many :watches, dependent: :destroy
  has_many :watched_auctions, through: :watches, source: :auction

  validates :first_name, presence: true
  validates :last_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: VALID_EMAIL_REGEX


  def full_name
    "#{first_name} #{last_name}".titleize
  end

end
