# Preview all emails at http://localhost:3000/rails/mailers/note
class NotePreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/note/gmail
  def gmail
    NoteMailer.gmail
  end

end
