class UserMailer < ActionMailer::Base
  def welcome_email(user)
    recipients    user.email
    from          "Landbook <noreply@landbook.com>"
    subject       "Information regarding landbook registration"
    sent_on       Time.now
    body          :user => user, :url => "http://example.com/"
  end
end
