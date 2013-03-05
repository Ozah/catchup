FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :info do
    content "soundcloud.com/Loremipsum"
    user
  end

  factory :meeting do
    latitude  100.0
    longitude 100.0
  end

end