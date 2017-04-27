FactoryGirl.define do
  factory :order do
    order_no { Faker::Number.number(10) }
    total { Faker::Number.decimal(2) }
    date { Faker::Date.between(2.days.ago, Date.today) }
    association :customer, factory: :customer
  end
end
