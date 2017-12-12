require 'rails_helper'

RSpec.describe "projects/index", type: :view do
  before(:each) do
    assign(:projects, [
      Project.create!(
        :name => "Name",
        :email => "Email",
        :phone => "Phone",
        :title => "Title",
        :first_date => "First Date",
        :location => "Location",
        :dates => "Dates",
        :artist_name => "Artist Name",
        :collaborators => "Collaborators",
        :home => "Home",
        :contact => "Contact",
        :links => "Links",
        :description => "Description",
        :image_href => "Image Href"
      ),
      Project.create!(
        :name => "Name",
        :email => "Email",
        :phone => "Phone",
        :title => "Title",
        :first_date => "First Date",
        :location => "Location",
        :dates => "Dates",
        :artist_name => "Artist Name",
        :collaborators => "Collaborators",
        :home => "Home",
        :contact => "Contact",
        :links => "Links",
        :description => "Description",
        :image_href => "Image Href"
      )
    ])
  end

  it "renders a list of projects" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "First Date".to_s, :count => 2
    assert_select "tr>td", :text => "Location".to_s, :count => 2
    assert_select "tr>td", :text => "Dates".to_s, :count => 2
    assert_select "tr>td", :text => "Artist Name".to_s, :count => 2
    assert_select "tr>td", :text => "Collaborators".to_s, :count => 2
    assert_select "tr>td", :text => "Home".to_s, :count => 2
    assert_select "tr>td", :text => "Contact".to_s, :count => 2
    assert_select "tr>td", :text => "Links".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Image Href".to_s, :count => 2
  end
end