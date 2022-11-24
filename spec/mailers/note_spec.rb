require 'rails_helper'

RSpec.describe NoteMailer  do
  

  describe 'gmail' do

    let(:mail) {NoteMailer.gmail("Test Body", "receiver@email.com", "Test title", "from@example.com")}
  

    it 'renders the subject' do
      expect(mail.subject).to eql('Test title')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql(['receiver@email.com'])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['from@example.com'])
    end
	end

end
