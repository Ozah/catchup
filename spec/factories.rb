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
    latitude  2.441416
    longitude 48.849325
  end

  factory :note do
    sequence(:content)  { |n| "Content #{n}" }
  end

  factory :venue do
    sequence(:name)  { |n| "Venue #{n}" }
    sequence(:latitude)  { |n| 2.4  }
    sequence(:longitude) { |n| 48.4  }   
  end

end