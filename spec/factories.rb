FactoryGirl.define do
  factory :user do
    name     "Olivier Zeller"
    email    "olivier@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end