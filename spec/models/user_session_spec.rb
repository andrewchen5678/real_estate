require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

#include Authlogic::TestCase

require "authlogic/test_case" # include at the top of test_helper.rb
#setup :activate_authlogic # run before tests are executed


describe UserSession do
  before(:all) do
    activate_authlogic
  end

  it "should have username and password" do
    @user_session = UserSession.new
    @user_session.should_not be_valid
    @user_session.errors.should have(1).error
    @user_session.errors.on_base.should == 'You did not provide any details for authentication.'
    #@user_session.error.should == 'You did not provide any details for authentication.'
  end

  it "should have email" do
    @user_session = UserSession.new(:password=>'a')
    @user_session.should_not be_valid
    @user_session.errors.should have(1).error_on(:email)
    @user_session.errors.on(:email).should == 'cannot be blank'
    #@user_session.errors.on_base.should == 'You did not provide any details for authentication.'
  end


end

