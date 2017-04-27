FactoryGirl.define do
  factory :customer do
    email { Faker::Internet.email }
    firstname { Faker::GameOfThrones.character }
    lastname { Faker::GameOfThrones.character }
    password { Faker::Internet.password(8) }
    password_confirmation { password }
    admin false

    factory :admin do
      after(:create) do |customer|
        customer.update_attribute(:admin, true)
      end
    end
  end
end
