class BidsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_auction, except: :index

  def index
    @user = current_user
    @bids = @user.bids
  end

  def new
    @bid = Bid.new
  end

  def create
    bid = Bid.new bid_params
    bid.auction = @auction
    bid.user = current_user

    if cannot? :bid, @auction
      redirect_to auction_path(@auction), alert: 'You can not bid on your own product'
    elsif bid.bid_price.present? && bid.bid_price < @auction.current_price
      redirect_to auction_path(@auction), alert: 'Your bid must be higher than the current price.'
    elsif bid.bid_price.present? && bid.bid_price >= @auction.current_price
      bid.save
      redirect_to auction_path(@auction), notice: "You submitted a bid"
    else
      redirect_to auction_path(@auction), alert: bid.errors.full_messages.join(', ')
    end
  end

  def edit
    @bid  = @auction.bids.find(params[:id])
  end

  def update
    @bid  = @auction.bids.find(params[:id])
    if @bid.update(bid_params)
      redirect_to auction_path(@auction), notice: 'Bid updated'
    else
      redirect_to auction_path(@auction), alert: @bid.errors.full_messages.join(', ')
    end
  end

  def destroy
    @bid  = @auction.bids.find(params[:id])
    if @bid.destroy
      redirect_to auction_path(@auction), notice: 'Bid deleted.'
    end
  end

  private

  def bid_params
    params.require(:bid).permit([:bid_price])
  end

  def find_auction
    @auction = Auction.find params[:auction_id]
  end

end
