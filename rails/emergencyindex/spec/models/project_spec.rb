require 'rails_helper'

RSpec.describe Project, type: :model do

  it 'has a working factory' do
    expect(FactoryBot.create(:project)).to be_valid
  end

end
