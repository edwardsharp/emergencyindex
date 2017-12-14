require 'rails_helper'

RSpec.describe "projects/show", type: :view do
  before(:each) do
    @project = assign(:project, Project.create!(
      :name => "Name",
      :email => "test@example.org",
      :phone => "1234567890",
      :title => "Title",
      :first_date => "First Date",
      :location => "Location",
      :dates => "Dates",
      :artist_name => "Artist Name",
      :collaborators => "Collaborators",
      :home => "Home",
      :contact => "Contact",
      :links => "Links",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/First Date/)
    expect(rendered).to match(/Location/)
    expect(rendered).to match(/Dates/)
    expect(rendered).to match(/Artist Name/)
    expect(rendered).to match(/Collaborators/)
    expect(rendered).to match(/Home/)
    expect(rendered).to match(/Contact/)
    expect(rendered).to match(/Links/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Image Href/)
  end
end
