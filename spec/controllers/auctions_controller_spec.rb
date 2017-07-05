require 'rails_helper'

RSpec.describe AuctionsController, type: :controller do

  def valid_request
    post :create, params: { auction: FactoryGirl.attributes_for(:auction) }
  end

  let(:user) { FactoryGirl.create(:user) }
  let(:auction) { FactoryGirl.create(:auction, {user: user})}

  describe '#index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe '#new' do
    context 'user not signed in' do
      it 'redirects to sign in page' do
        get :new
        expect(response).to redirect_to(new_session_path)
      end
    end
    context 'user signed in' do
      before do
        user = FactoryGirl.create(:user)
        request.session[:user_id] = user.id
        get :new
      end
      it 'renders new template' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe '#create' do
    context "with signed in user" do
      before do
        user = FactoryGirl.create(:user)
        request.session[:user_id] = user.id
        get :new
      end
      it 'creates a new auction in the database' do
        count_before = Auction.count
        valid_request
        count_after = Auction.count
        expect(count_after).to eq(count_before + 1)
      end
      it 'redirects to the auctions index page / home path' do
        valid_request
        expect(response).to redirect_to(auction_path(Auction.last))
      end
    end
  end

  describe '#edit' do
    context 'with user signed in' do
       before { request.session[:user_id] = user.id }
       it 'renders the edit template' do
         get :edit, params: { id: auction.id }
         expect(response).to render_template(:edit)
       end
       it 'sets an instance variable to the auction whose id was passed' do
        get :edit, params: { id: auction.id }
        expect(assigns(:auction)).to eq(auction)
      end
    end
  end

  describe '#destroy' do
    context 'with no signed in user' do
      it 'redirects to the home page' do
        delete :destroy, params: { id: auction.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
    context 'with signed in user' do
      before { request.session[:user_id] = user.id }
      it 'removes the auction record from the database' do
        auction
        count_before = Auction.count
        delete :destroy, params: { id: auction.id }
        count_after  = Auction.count
        expect(count_after).to eq(count_before - 1)
      end
    end
  end
end
