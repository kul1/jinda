# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notes API', type: :request do
  let!(:admin_user) { User.create(code: 'admin', email: 'admin@example.com', role: 'Admin') }
  let!(:note) { FactoryBot.create_list(:note, 9, user: admin_user) }
  before do
    allow_any_instance_of(Api::V1::NotesController).to receive(:current_ma_user).and_return(admin_user)
    get api_v1_notes_my_path
  end

  it 'returns all notes' do
    expect(json.size).to eq(9)
  end
  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end
end
