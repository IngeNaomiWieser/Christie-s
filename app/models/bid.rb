class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :auction

  validates :bid_price, presence: true

  after_save :update_auction_current_price

  def update_auction_current_price
    self.auction.current_price = self.bid_price
    self.auction.save
  end
end
