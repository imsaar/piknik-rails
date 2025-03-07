FactoryBot.define do
  factory :potluck_signup, class: 'Potluck::Signup' do
    potluck_item { nil }
    email { "MyString" }
    name { "MyString" }
    quantity { 1 }
    confirmed { false }
    confirmation_token { "MyString" }
  end
end
