FactoryBot.define do
  factory :dish do
    name { "MyString" }
    description { "MyText" }
    quantity_needed { 1 }
    quantity_signed_up { 1 }
    event { nil }
  end
end
