require 'rails_helper'
# describe Api::V1::NotesController, '#index', type: :request do
RSpec.describe 'Notes API', type: :request do
	# let(:notes) { create_list(:note,1)}
  # let!(:notes) {Note.create(title: "dddd", body: "body")}
  let!(:note) {FactoryBot.create_list(:note, 9)}
	let(:note_id) { notes.first.id }

	describe 'GET /api/v1/notes' do
 		before { get api_v1_notes_path }
		
		it 'returns notes size as expected' do
			expect(json).not_to be_empty
			expect(json.size).to eq(9)
		end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end 

	end
end

