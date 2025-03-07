require 'rails_helper'

RSpec.describe "Dishes", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/dishes/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/dishes/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/dishes/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/dishes/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
