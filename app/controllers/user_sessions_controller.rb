class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user_session, :only => :destroy
  #prepend_before_filter :setdontredirect

  def new
    @user_session = UserSession.new
    if(params[:plain]=='1')
      render :layout=>'plain'
    end
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
#      if(current_user.regcomplete)
        redirect_stored_or_default account_url
#      else
#        redirect_to_complete_profile
#      end
    else
      if(params[:plain]=='1')
        render :action => :new,:layout=>'plain'
      else
        render :action => :new
      end
      
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to login_url
  end

  protected
   def redirect_stored_or_default(default)
     return_to = params[:return_to]
     #logger.debug('return to '+return_to[0]);
     #only relative url
     if !return_to.blank? && return_to[0,1]=='/'
       #session[:return_to] = nil
       redirect_to(return_to)
     else
       redirect_to default
     end #if
   end #redirect_to_stored
end
