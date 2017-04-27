FactoryGirl.define do
  factory :product do
    name { Faker::GameOfThrones.character }
    description { Faker::Lorem.sentences(1) }
    price { Faker::Number.decimal(2) }
    status 0

    factory :disabled_product do
      after(:create) do |product|
        product.update_attribute(:status, 1)
      end
    end
  end
end
