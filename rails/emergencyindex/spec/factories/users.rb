FactoryBot.define do
  factory :user do
    name "test user"
    phone "1234567890"
    email { "user#{SecureRandom.hex}@example.org" }
    password "password"
    password_confirmation "password"
    confirmed_at Time.now
  end

  factory :admin, class: User do
    name "test admin user"
    phone "1234567890"
    email { "admin#{SecureRandom.hex}@example.org" }
    password "password"
    password_confirmation "password"
    confirmed_at Time.now
    admin true
  end

  factory :unconfirmed, class: User do
    name "unconfirmed user jr."
    phone "1234567890"
    email { "unconfirmed#{SecureRandom.hex}@example.org" }
    password "password"
    password_confirmation "password"
  end

end
