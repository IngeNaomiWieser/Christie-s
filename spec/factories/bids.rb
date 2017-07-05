FactoryGirl.define do
  factory :bid do
    association :user, factory: :user
    association :auction, factory: :auction
    bid_price {Faker::Number.between(10, 1000)}
  end
end
