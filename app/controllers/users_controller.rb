class UsersController < ApplicationController
  #before_filter :login_required, :only=>['welcome', 'change_password', 'hidden']
  #prepend_before_filter :setdontredirect, :only => [:edit, :update]
  prepend_before_filter :setdontredirect, :only => [:new, :create]
  #before_filter :require_user, :only => [:show, :edit, :update, :updatepics,:showfavorites]
  before_filter :require_user, :except=>[:new,:create]
  before_filter :require_no_user, :only=>[:new,:create]
  before_filter :require_user_session, :only=>[:new,:create]
  before_filter :get_right_user, :only => [:show, :edit, :update] #account
  before_filter :check_permission, :only => [:edit, :update, :updatepics,:showfavorites]
  
  def new
    @auth= current_user_session.user_auth
    @current_user=current_user_session.user_auth.user
    @user = @auth.build_user
    if(params[:user_type]=='agent')
      @user = @user.becomes(Agent)
    else
      @user = @user.becomes(RegularUser)
    end
    @user.build_profile
  end

#  def index
#
#  end

  def create
    @auth= current_user_session.user_auth
    @current_user=current_user_session.user_auth.user
    @auth.password=params[:user_auth][:password]
    @auth.password_confirmation=params[:user_auth][:password_confirmation]
    @user = @auth.build_user
#    @user = RegularUser.new if(@auth.user_type=='RegularUser')
#    @user = Agent.new if(@auth.user_type=='Agent')
    if(params[:user_type]=='agent')
      @user.type='Agent'
      @user = @user.becomes(Agent)
    else
      @user.type='RegularUser'
      @user = @user.becomes(RegularUser)
    end
    @user.build_profile
    @user.attributes=params[:user]
    @user.id=@auth.id
    @user.email=@auth.email
    valid=@user.valid?
    valid=@auth.valid? && valid
    logger.debug(@user.inspect)
    #@user.regcomplete=true
    if valid
      @auth.save(false)
      #logger.debug(@user.inspect)
      flash[:notice] = "Account create complete!"
      redirect_to account_url
    else
      render :action => :new
    end
  end

  def show
    @user_profile=@user.profile
  end

  def edit
    @user.build_profile if @user.profile.nil?
    @auth=UserAuth.find(@user.id)
    params[:user_type]='agent' if @user.instance_of?(Agent)
  end

  def update
    @user.build_profile if @user.profile.nil?
    @auth=UserAuth.find(@user.id)
    #params[:user_type]='agent' if @user.instance_of?(Agent)

    @auth.password=params[:user_auth][:password]
    @auth.password_confirmation=params[:user_auth][:password_confirmation]
    @user.attributes=params[:user]

    valid=@user.valid?
    valid=@auth.valid? && valid
    #@user.regcomplete=true
    if valid
      @auth.save(false)
      @user.save(false)
      #logger.debug(@user.inspect)
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end

  def updatepics
    #@user=User.find(params[:id])
    helper_render_updatepics @user
  end

  def showads
    @user=User.find(params[:id])
    case params[:adtype]
    when 'rr_sales'
      @rr_sales=@user.rr_sales.paginate :page => params[:page]
      render 'rr_sales'
    when 'residential_realties'
      @residential_realties=@user.residential_realties.paginate :page => params[:page]
      render 'residential_realties'
    else
      @rr_sales=@user.rr_sales.paginate :page => params[:page]
      render 'rr_sales'
    end
  end

  def showfavorites
    #@user=User.find(params[:id])
    if(params[:delfav])
      favdel=@user.favorites.find(params[:delfav])
      favdel.destroy
      redirect_to :action=>'showfavorites'
    end
    @favorites=@user.favorites.paginate :page => params[:page], :include=>'favoritable'
  end

  protected
  def get_right_user
    if(params[:id])
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end
#  def signup
#    @user = User.new(params[:user])
#    if request.post?
#      if @user.save
#        session[:user] = User.authenticate(@user.login, @user.password)
#        flash[:notice] = "Signup successful"
#        redirect_to :action => "welcome"
#      else
#        flash[:warning] = "Signup unsuccessful"
#      end
#    end
#  end

  # def login
    # #@user=User.new
    # if request.post?
      # logger.debug("login "+params[:auth][:email])
      # logger.debug("pass "+params[:auth][:password])
      # #logger.debug(params)
      # @auth=Auth.new(params[:auth])
      
      # if !@auth.valid?
        # logger.debug(@auth.errors)
        # return
      # end
      # loginsuccess=@auth.authenticate()
      # if loginsuccess
        # session[:userid] = loginsuccess.id
        # logger.debug('session user id'+session[:userid].to_s);
        # flash[:notice]  = "Login successful"
        # redirect_to_stored
      # end #if loginsuccess
    # end #if post
  # end #login

  # def logout
    # #session[:user] = nil
    # #User.logout
    # reset_session
    # flash[:notice] = 'Logged out'
    # redirect_to :action => 'login'
  # end

  # private
  
  # def redirect_to_stored
    # return_to = params[:return_to]
    # #logger.debug('return to '+return_to[0]);
    # #only relative url
    # if !return_to.blank? && return_to[0,1]=='/'
      # #session[:return_to] = nil
      # redirect_to(return_to)
    # else
      # redirect_to :controller => 'home'
    # end #if
  # end #redirect_to_stored

#  def forgot_password
#    if request.post?
#      u= User.find_by_email(params[:user][:email])
#      if u and u.send_new_password
#        flash[:notice]  = "A new password has been sent by email."
#        redirect_to :action=>'login'
#      else
#        flash[:warning]  = "Couldn't send password"
#      end
#    end
#  end
#
#  def change_password
#    @user=session[:user]
#    if request.post?
#      @user.update_attributes(:password=>params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
#      if @user.save
#        flash[:notice]="Password Changed"
#      end
#    end
#  end
#
#  def welcome
#  end
#  def hidden
#  end
  def check_permission
      @user = User.find(params[:id]) if(!@user)
      if current_user.id!=@user.id
        #store_location
        flash[:warning] = "Permission denied"
        redirect_to root_url
        return false
#      elsif !current_user.regcomplete
#        redirect_to_complete_profile
#        return false
      end
  end

end
