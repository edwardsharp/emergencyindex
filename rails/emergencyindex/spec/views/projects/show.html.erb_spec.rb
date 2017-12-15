require 'rails_helper'

RSpec.describe "projects/show", type: :view do
  before(:each) do
    @project = assign(:project, FactoryBot.create(:project))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyString/)
    expect(rendered).to match(/A project description./)
  end
end
