require 'rails_helper'

RSpec.describe IndexesController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #terms" do
    it "returns http success" do
      get :terms
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #contributors" do
    it "returns http success" do
      get :contributors
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #places" do
    it "returns http success" do
      get :places
      expect(response).to have_http_status(:success)
    end
  end

end
