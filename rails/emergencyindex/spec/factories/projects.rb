FactoryBot.define do
  factory :project do
    title "Project Title"
    first_date "1/1/2017"
    location "Panoply Performance Laboratory"
    dates "666 times in 2017"
    artist_name "3dwardsharp"
    collaborators ""
    home "Brooklyn, NY"
    contact "hello@lacuna.club"
    links "http://edwardsharp.net"
    description "A project description."
    user
  end
end
