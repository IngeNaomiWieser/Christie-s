class AddUserReferencesToAuctions < ActiveRecord::Migration[5.1]
  def change
    add_reference :auctions, :user, foreign_key: true, index: true
  end
end
