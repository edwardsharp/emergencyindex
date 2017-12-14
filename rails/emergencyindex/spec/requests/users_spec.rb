require 'rails_helper'

RSpec.describe "Users", type: :request do

  it "can sign_in" do
    get new_user_session_url
    expect(response).to have_http_status(200)
  end

  it "can sign_up" do
    get new_user_registration_url
    expect(response).to have_http_status(200)
  end

end

#         new_user_session GET    /users/sign_in(.:format)          devise/sessions#new
#        new_user_password GET    /users/password/new(.:format)     devise/passwords#new
#       edit_user_password GET    /users/password/edit(.:format)    devise/passwords#edit
# cancel_user_registration GET    /users/cancel(.:format)           devise/registrations#cancel
#    new_user_registration GET    /users/sign_up(.:format)          devise/registrations#new
#   edit_user_registration GET    /users/edit(.:format)             devise/registrations#edit
#    new_user_confirmation GET    /users/confirmation/new(.:format) devise/confirmations#new
#        user_confirmation GET    /users/confirmation(.:format)     devise/confirmations#show
#          new_user_unlock GET    /users/unlock/new(.:format)       devise/unlocks#new
#              user_unlock GET    /users/unlock(.:format)           devise/unlocks#show
