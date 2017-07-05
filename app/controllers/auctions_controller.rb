class AuctionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_auction, only: [:show, :edit, :update, :destroy]

  def index
    @auctions = Auction.order(created_at: :desc)
  end

  def show
    @bids = Bid.where(auction_id: @auction).order(bid_price: :desc)
    @newbid = @auction.bids.new
  end

  def new
    @auction = Auction.new
  end

  def create
    @auction = Auction.new auction_params
    @auction.user = current_user
    if @auction.save
      redirect_to auction_path(@auction), notice: 'You created a new auction!'
    else
      render :new, alert: @auction.errors.full_messages.join(', ')
    end
  end

  def edit
    if !(can? :edit, @auction)
      redirect_to auction_path(@auction), alert: 'Access denied. You may not edit this auction.'
    end
  end

  def update
    if !(can? :edit, @auction)
      redirect_to auction_path(@auction), alert: 'Access denied'
    elsif @auction.update(auction_params)
      redirect_to auctions_path, notice: 'Your auction was updated!'
    else
      render :edit, alert: 'Something went wrong!'
    end
  end

  def destroy
    if can? :destroy, @auction
      @auction.destroy
      redirect_to auctions_path, notice: 'Auction delete'
    else
      redirect_to auction_path(@auction), alert: 'access denied'
    end
  end

  private

  def find_auction
    @auction = Auction.find params[:id]
  end

  def auction_params
    params.require(:auction).permit(
      :title,
      :details,
      :end_date,
      :reserve_price
    )
  end
end
