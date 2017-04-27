FactoryGirl.define do
  factory :order_line do
    qty { Faker::Number.number(1) }
    unit_price { Faker::Number.decimal(2) }
    total_price { Faker::Number.decimal(2) }
    association :order, factory: :order
    association :product, factory: :product
  end
end
