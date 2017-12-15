FactoryBot.define do
  factory :user do
    email { "user#{SecureRandom.hex}@example.org" }
    password "password"
    password_confirmation "password"
    confirmed_at Time.now
  end

  factory :admin, class: User do
    email { "admin#{SecureRandom.hex}@example.org" }
    password "password"
    password_confirmation "password"
    confirmed_at Time.now
    admin true
  end

  factory :unconfirmed, class: User do
    email { "unconfirmed#{SecureRandom.hex}@example.org" }
    password "password"
    password_confirmation "password"
  end

end
