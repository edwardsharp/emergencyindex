require 'rails_helper'

RSpec.describe "projects/index", type: :view do
  before(:each) do
    assign(:projects, [
      FactoryBot.create(:project),
      FactoryBot.create(:project)
    ])
  end

  it "renders a list of projects" do
    render
    assert_select "tr>td", :text => "MyString".to_s
  end
end
