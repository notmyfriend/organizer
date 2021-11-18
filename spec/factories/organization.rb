FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }
    description { Faker::Lorem.paragraph(sentence_count: 2, supplemental: false, random_sentences_to_add: 4) }
    association :user
  end
end
