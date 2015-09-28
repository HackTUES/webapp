User.create!(name:  "Example Admin",
             email: "admin@example.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now,
             number: 1,
             klas: 1,
             section: 'A')

 User.create!(name:  "Example User",
              email: "user@example.com",
              password:              "foobar",
              password_confirmation: "foobar",
              activated: true,
              activated_at: Time.zone.now,
              number: 1,
              klas: 1,
              section: 'A')

99.times do |n|
  name  = Faker::Name.name
  email = "user-#{n+1}@example.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now,
               number: 1,
               klas: 1,
               section: 'A')
end
