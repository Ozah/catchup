FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    sequence(:remember_token)  { |n| "#{n}" }
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end

    factory :user_at_home_now do
      longitude 2.441416
      latitude 48.849325
      location_time { Time.now }
    end

    factory :user_3m_away_now do
      longitude 2.441381
      latitude 48.849314
      location_time { Time.now }
    end

    factory :user_3m_away_15m_ago do
      longitude 2.441381
      latitude 48.849314
      location_time { Time.now - 15.minutes }
    end

    factory :user_30m_away_now do
      longitude 2.441785 
      latitude 48.849423
      location_time { Time.now }
    end

    factory :user_100m_away_now do
      longitude 2.442739 
      latitude 48.849449
      location_time { Time.now }
    end
    
  end

  factory :info do
    content "soundcloud.com/Loremipsum"
  end

  factory :meeting do
    latitude  100.0
    longitude 100.0
  end

end