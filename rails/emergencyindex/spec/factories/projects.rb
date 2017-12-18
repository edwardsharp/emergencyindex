FactoryBot.define do
  factory :project do
    title "Project Title"
    name "3dwardsharp"
    already_submitted false
    first_date "1/1/2017"
    sequence :times_performed do |n|
      n
    end
    venue "Panoply Performance Laboratory"
    city "Brooklyn"
    state_country "NY, USA"
    home "Brooklyn, NY"
    description "A project description."
    user
  end
end
