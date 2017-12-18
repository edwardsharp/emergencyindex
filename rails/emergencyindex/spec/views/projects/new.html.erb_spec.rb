require 'rails_helper'

RSpec.describe "projects/new", type: :view do
  
  # before(:each) do
    # @request.env["devise.mapping"] = Devise.mappings[:user]
    # sign_in FactoryBot.create(:user)
    # assign(:project, FactoryBot.create(:project))
  # end

  it "renders new project form" do
    
    render

    assert_select "form[action=?][method=?]", new_project_path, "post" do

      assert_select "input[name=?]", "title"

      assert_select "input[name=?]", "name"

      assert_select "input[name=?]", "first_date"

      assert_select "input[name=?]", "times_performed"

      assert_select "input[name=?]", "venue"

      assert_select "input[name=?]", "home"

      assert_select "input[name=?]", "published_contact"

      assert_select "input[name=?]", "links"

      assert_select "textarea[name=?]", "description"

    end
  end
end
