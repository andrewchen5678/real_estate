class AdMailer < ActionMailer::Base
  helper :application
  def rr_sale_mail(from_name,from_email,to_name,to_email,subject,url,message='')
    recipients    to_email
    from          "#{from_name} <#{from_email}>"
    subject       subject
    sent_on       Time.now
    body          :from_name => from_name,:to_name => to_name,:url => url,:email_message=>message
  end

  def rr_sale_mail_cur_user(userobj,to_name,to_email,subject,url,user_url,message='')
    @template='rr_sale_mail'
    from_name=userobj.nickname
    from_email=userobj.email
    recipients    to_email
    from          "#{from_name} <#{from_email}>"
    subject       subject
    sent_on       Time.now
    body          :userobj=>userobj,:to_name=>to_name,:url => url,:email_message=>message,:user_url=>user_url
  end
end
