class ProfilesControlchafa
  before_filter :require_user
  before_filter :check_permission
  #before_filter :get_and_check_profile, :only => [:edit, :update]

  def new
    @user=User.find(params[:user_id])
    if @user.profile
      redirect_to :action=>:edit
    else
      @user_profile=@user.build_profile
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @user_profile }
      end
    end
  end

  def create
    @user=User.find(params[:user_id])
    if @user.profile
      redirect_to :action=>:edit
    end
    if(@user.kind_of?(Agent))
      @user_profile=@user.build_profile(params[:agent_profile])
    elsif (@user.kind_of?(RegularUser))
      @user_profile=@user.build_profile(params[:regular_user_profile])
    end
    @user.coverpic=params[:user][:coverpic]
    @user.regcomplete=true
    valid=@user.valid?
    valid=@user_profile.valid? && valid
    if(valid)
      @user.save(false) && @user_profile.save(false)
    end
      #logger.debug("franchise"+params[:business][:franchise])
    respond_to do |format|
      if valid
        flash[:notice] = 'Profile was successfully created.'
        format.html { redirect_to(account_url) }
        format.xml  { render :xml => @user_profile, :status => :created, :location => @user_profile }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @user=User.find(params[:user_id])
    @user_profile=@user.profile
  end

  def update
    @user=User.find(params[:user_id])
    @user.coverpic=params[:user][:coverpic] if params[:user][:coverpic]
    @user_profile=@user.profile
    if(@user.kind_of?(Agent))
      @user_profile.attributes=params[:agent_profile]
    elsif (@user.kind_of?(RegularUser))
      @user_profile.attributes=params[:regular_user_profile]
    end
    valid=@user.valid?
    valid=@user_profile.valid? && valid
    if(valid)
      @user.save(false) && @user_profile.save(false)
    end
    respond_to do |format|
      if valid
        flash[:notice] = 'User profile was successfully updated.'
        format.html { redirect_to(account_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user_profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  protected
  def check_permission
      if current_user.id!=params[:user_id].to_i
        #store_location
        flash[:warning] = "Can't update other people's profile"
        redirect_to root_url
        return false
#      elsif !current_user.regcomplete
#        redirect_to_complete_profile
#        return false
      end
  end
#  def get_and_check_business
#    @profile = UserProfile.find(params[:user_id])
#    return check_if_user_can_edit(@profile)
#  end
end
