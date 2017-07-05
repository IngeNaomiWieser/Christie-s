FactoryGirl.define do
  factory :auction do
    association :user, factory: :user
    title {Faker::Book.title}
    details {Faker::Hacker.say_something_smart}
    end_date {Faker::Date.forward(30)}
    reserve_price {Faker::Number.between(10, 2000)}
    current_price {1}
  end
end
