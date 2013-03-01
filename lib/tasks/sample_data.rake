namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Oli",
                 email: "o.zeller@gmail.com",
                 password: "foobar",
                 password_confirmation: "foobar")
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@catchup.com"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    users = User.all(limit: 6)
    5.times do
      content = "www." << Faker::Internet.domain_name
      users.each { |user| user.infos.create!(content: content) }
    end
  end
end