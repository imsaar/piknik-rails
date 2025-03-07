require 'rails_helper'

RSpec.describe "Signups", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/signups/create"
      expect(response).to have_http_status(:success)
    end
  end

end
