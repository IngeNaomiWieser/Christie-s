module ApplicationHelper

  def user_bid(auction)
     auction.bids.where(user_id: current_user&.id)&.first
  end

end
