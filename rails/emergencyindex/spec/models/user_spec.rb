require 'rails_helper'

RSpec.describe User, type: :model do
  
  it 'has a working factory' do
    expect(FactoryBot.create(:user)).to be_valid
  end
  
end
