require 'test_helper'
require 'user_session'
require "authlogic/test_case" # include at the top of test_helper.rb


class UserSessionTest < Test::Unit::TestCase
 context "A User instance" do
  setup do
    activate_authlogic # run before tests are executed
  end
      should "have username and password" do
        @user_session = UserSession.new
        assert !@user_session.valid?
        assert_equal @user_session.errors.length,1
        assert_equal @user_session.errors.on_base,'You did not provide any details for authentication.'
      end

  should "have email" do
    @user_session = UserSession.new(:password=>'a')
    assert !@user_session.valid?
    assert_equal @user_session.errors.length,1
    assert_equal @user_session.errors.on(:email),'cannot be blank'
    #@user_session.errors.on_base.should == 'You did not provide any details for authentication.'
  end

 end
end
