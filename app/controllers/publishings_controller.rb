class PublishingsController < ApplicationController
  before_action :authenticate_user!

  def create
    auction = Auction.find params[:auction_id]
    if auction.publish!
      redirect_to auction, notice: 'Auction is published!'
    else
      redirect_to auction, alert: 'Can\'t publish your auction, was it already published?'
    end
  end

end
