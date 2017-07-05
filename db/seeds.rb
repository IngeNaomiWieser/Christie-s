# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Auction.destroy_all
Bid.destroy_all

User.create(
  first_name: "Inge",
  last_name: "Wieser",
  email: "inge@gmail.com",
  password: "1234",
  password_confirmation: "1234"
)

#create users
10.times do
  User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: '1234',
    password_confirmation: '1234'
    )
    puts "User was created!"
  end

#create auctions
30.times do
  # pluck only gives that field from the table and puts into something like an array so you can do sample on it
  Auction.create(
    title: Faker::Book.title,
    details: Faker::Hacker.say_something_smart,
    end_date: Faker::Date.forward(30),
    reserve_price: Faker::Number.between(10, 2000),
    user_id: User.pluck(:id).sample,
    current_price: 1
  )
    puts "Auction was created!"
end

#create bids
100.times do
  auction = Auction.order("RANDOM()").first
  highest_bid_price = auction.bids.last&.bid_price || 0
  Bid.create(
    bid_price: highest_bid_price + Faker::Number.between(10, 25),
    user_id: User.pluck(:id).sample,
    auction_id: auction.id
  )
  puts "Bid was created!"
end
