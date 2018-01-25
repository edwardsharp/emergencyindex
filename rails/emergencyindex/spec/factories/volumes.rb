FactoryBot.define do
  factory :volume do
    sequence :year do |n|
      2000 + n
    end
    open_date_string "2018/01/19"
    close_date_string "2018/01/19"
  end
end
