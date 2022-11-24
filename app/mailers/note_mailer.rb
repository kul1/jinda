class NoteMailer < ActionMailer::Base
  default from: "from@example.com"
  
  def gmail(body , to="", subject="", from="")
    @body   = body
    @title  = subject
    @from   = from
    mail(:to => to, :subject => subject, :from => from)
  end
end
