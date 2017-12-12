require 'rails_helper'

RSpec.describe "projects/new", type: :view do
  before(:each) do
    assign(:project, Project.new(
      :name => "MyString",
      :email => "MyString",
      :phone => "MyString",
      :title => "MyString",
      :first_date => "MyString",
      :location => "MyString",
      :dates => "MyString",
      :artist_name => "MyString",
      :collaborators => "MyString",
      :home => "MyString",
      :contact => "MyString",
      :links => "MyString",
      :description => "MyString",
      :image_href => "MyString"
    ))
  end

  it "renders new project form" do
    render

    assert_select "form[action=?][method=?]", projects_path, "post" do

      assert_select "input[name=?]", "project[name]"

      assert_select "input[name=?]", "project[email]"

      assert_select "input[name=?]", "project[phone]"

      assert_select "input[name=?]", "project[title]"

      assert_select "input[name=?]", "project[first_date]"

      assert_select "input[name=?]", "project[location]"

      assert_select "input[name=?]", "project[dates]"

      assert_select "input[name=?]", "project[artist_name]"

      assert_select "input[name=?]", "project[collaborators]"

      assert_select "input[name=?]", "project[home]"

      assert_select "input[name=?]", "project[contact]"

      assert_select "input[name=?]", "project[links]"

      assert_select "input[name=?]", "project[description]"

      assert_select "input[name=?]", "project[image_href]"
    end
  end
end