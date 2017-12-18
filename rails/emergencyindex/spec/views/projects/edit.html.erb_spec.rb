require 'rails_helper'

RSpec.describe "projects/edit", type: :view do
  before(:each) do
    @project = assign(:project, FactoryBot.create(:project))
  end

  it "renders the edit project form" do
    render

    assert_select "form[action=?][method=?]", project_path(@project), "post" do

      assert_select "input[name=?]", "project[title]"

      assert_select "input[name=?]", "project[first_date]"

      assert_select "input[name=?]", "project[location]"

      assert_select "input[name=?]", "project[dates]"

      assert_select "input[name=?]", "project[artist_name]"

      assert_select "input[name=?]", "project[collaborators]"

      assert_select "input[name=?]", "project[home]"

      assert_select "input[name=?]", "project[contact]"

      assert_select "input[name=?]", "project[links]"

      assert_select "textarea[name=?]", "project[description]"

    end
  end
end
