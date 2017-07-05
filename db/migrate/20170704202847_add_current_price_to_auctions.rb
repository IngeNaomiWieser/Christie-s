class AddCurrentPriceToAuctions < ActiveRecord::Migration[5.1]
  def change
    add_column :auctions, :current_price, :float
  end
end
