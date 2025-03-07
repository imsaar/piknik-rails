FactoryBot.define do
  factory :signup do
    dish { nil }
    participant_name { "MyString" }
    participant_email { "MyString" }
    quantity { 1 }
    confirmed { false }
  end
end
