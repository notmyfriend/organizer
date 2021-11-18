FactoryBot.define do
  factory :user do
    role { :client }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.safe_email }
    password { Faker::Internet.password(min_length: 6) }
    confirmed_at { 1.day.ago }
  end
end
