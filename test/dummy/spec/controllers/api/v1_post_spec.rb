require 'rails_helper'
describe Api::V1::NotesController , type: :controller do

  before do
    create_and_sign_in_user
    post :create , params: { :body => 'test_body', :title => 'test_title', :user => User.first}
  end

  it 'returns the title' do
    expect(JSON.parse(@response.body)['title']).to eq('test_title')
  end
  it 'returns the body' do
    expect(JSON.parse(@response.body)['body']).to eq('test_body')
  end

  it 'returns a created status' do
    expect(response).to have_http_status(:created)
  end
end
