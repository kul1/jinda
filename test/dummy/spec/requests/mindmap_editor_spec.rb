require 'rails_helper'

RSpec.describe "MindmapEditors", type: :request do
  describe "GET /edit" do
    it "returns http success" do
      get "/mindmap_editor/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /save" do
    it "returns http success" do
      get "/mindmap_editor/save"
      expect(response).to have_http_status(:success)
    end
  end

end
