# app/models/notifier.rb
class Notifier < ActionMailer::Base
  #default_url_options[:host] = "authlogic_example.binarylogic.com"

  def password_reset_instructions(user,host,port)
    subject       "Password Reset Instructions"
    from          "Landbook Notifier <noreply@#{host}>"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token,:host =>host,:port=>port)
  end
end
