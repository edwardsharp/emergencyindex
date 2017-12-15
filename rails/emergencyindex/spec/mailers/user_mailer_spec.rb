require "rails_helper"

RSpec.describe User, :type => :mailer do
  it 'sends a confirmation email' do
    user = FactoryBot.build :unconfirmed
    expect { user.save }.to change(ActionMailer::Base.deliveries, :count).by(1)
  end
end
