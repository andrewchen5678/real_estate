# To change this template, choose Tools | Templates
# and open the template in the editor.

class UserAuthsController < ApplicationController
    before_filter :require_no_user, :only => [:new, :create]
  def new
    @user_auth = UserAuth.new
  end

#  def index
#
#  end

  def create
    @user_auth = UserAuth.new(params[:user_auth])
    pass=UserAuth.random_string(8)
    @user_auth.password=pass
    @user_auth.password_confirmation=pass
    #@user_auth.regcomplete=false
    #@user_auth.regstep=1
    #@user_auth.user_type=params[:user_auth][:type]
    if @user_auth.save_without_session_maintenance
      flash[:notice] = "Account registered!"
      redirect_to root_url
    else
      render :action => :new
    end
  end
end
