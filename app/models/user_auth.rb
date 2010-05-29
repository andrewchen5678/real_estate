
class UserAuth < ActiveRecord::Base
  acts_as_authentic do |c|
    c.session_class= UserSession
    #c.login_field = :email # for available options see documentation in: Authlogic::ActsAsAuthentic
    #c.validate_login_field=false
  end # block optional

  has_one :user, :foreign_key=>:id

  #validates_inclusion_of :user_type, :in =>%w(RegularUser Agent)

  def after_create
    UserMailer.deliver_welcome_email(self)
  end

  def deliver_password_reset_instructions! host,port
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self,host,port)
  end

  def self.random_string(len)
    #generate a random password consisting of strings and digits
    chars = ["a", "b", "c", "d", "e", "f", "g",
             "h", "i", "j", "k", "l", "m", "n",
             "o", "p", "q", "r", "s", "t",
             "u", "v", "w", "x", "y", "z",
             "A", "B", "C", "D", "E", "F", "G",
             "H", "I", "J", "K", "L", "M", "N",
             "O", "P", "Q", "R", "S", "T",
             "U", "V", "W", "X", "Y", "Z",
             "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    newpass = ""
    1.upto(len) { newpass << chars[rand(chars.size-1)] }
    return newpass
  end
end
