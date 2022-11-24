require 'rails_helper'

RSpec.describe 'Notes API', type: :request do
  let!(:note) {FactoryBot.create_list(:note, 9)}
  before {get api_v1_notes_my_path}

  it 'returns all notes' do
			expect(json.size).to eq(9)
  end
  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end
end

