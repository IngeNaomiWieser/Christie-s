require 'rails_helper'

RSpec.describe BidsController, type: :controller do

  let(:user) { FactoryGirl.create(:user) }
  let(:auction) { FactoryGirl.create(:auction)}
  let(:bid) { FactoryGirl.create(:bid, {auction: auction})}

  def valid_request
    post :create, params: {
      auction_id: auction.id,
      user_id: user.id,
      bid: {
        bid_price: Faker::Number.between(10, 1000),
        auction_id: auction.id,
        user_id: user.id
      }
    }
  end

  describe '#create' do
    context "with signed in user" do
      before do
        request.session[:user_id] = user.id
      end
      it 'creates a new bid in the database' do
        count_before = Bid.count
        valid_request
        count_after = Bid.count
        expect(count_after).to eq(count_before + 1)
      end
      it 'redirects to the auctions show page' do
        valid_request
        expect(response).to redirect_to(auction_path(Bid.last.auction))
      end
      it 'associates the created auction with the signed in user' do
        valid_request
        expect(Bid.last.user).to eq(user)
      end
      it 'sets a flash message' do
        valid_request
        expect(flash[:notice]).to be
      end
    end
  end

  describe '#destroy' do
    context 'with signed in user' do
    before { request.session[:user_id] = user.id }
      it 'removes the auction record from the database' do
        bid
        count_before = Bid.count
        delete :destroy, params: {
          auction_id: auction.id,
          id: bid.id }
        count_after  = Bid.count
        expect(count_after).to eq(count_before - 1)
      end
      it 'redirects to the auctions show page' do
        valid_request
        expect(response).to redirect_to(auction_path(Bid.last.auction))
      end
      it 'sets a flash notice message' do
        valid_request
        expect(flash[:notice]).to be
      end
    end
  end
end
