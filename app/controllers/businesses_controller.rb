class BusinessesController < ApplicationController
  #before_filter :login_required, :only => [:new, :create, :destroy, :edit, :update]
  before_filter :require_user, :only => [:new, :create, :destroy, :edit, :update,:updatepics]
  before_filter :get_and_check_business, :only => [:edit, :update,:updatepics]
#  before_filter :get_state_list
#
#  def get_state_list
#    @state_list=State.all
#  end
#
  # GET /businesses
  # GET /businesses.xml
  def index
    #page = params[:page] || 1
#@posts = Post.paginate_by_board_id @board.id, :page => page, :order => 'updated_at DESC'
    @businesses = Business.paginate :page => params[:page], :order => 'created_at DESC', :include => [:user,:address]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @businesses }
    end
  end

  # GET /businesses/1
  # GET /businesses/1.xml
  def show
    @business = Business.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @business }
    end
  end

  # GET /businesses/new
  # GET /businesses/new.xml
  def new
    @business = Business.new(:franchise=>false)
    #@business.build_singleImage
    @address=Address.new
#    @frontpic=SingleImage.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @business }
    end
  end

  # GET /businesses/1/edit
  def edit
    @currentimg=helper_get_current_image @business
    @address=@business.address
#    @frontpic=SingleImage.new
  end

  # POST /businesses
  # POST /businesses.xml
  def create
    @business = Business.new(params[:business])
    @business.user_id=current_user.id
    valid=help_process
      #logger.debug("franchise"+params[:business][:franchise])
    respond_to do |format|
      if valid
        flash[:notice] = 'Business was successfully created.'
        format.html { redirect_to(@business) }
        format.xml  { render :xml => @business, :status => :created, :location => @business }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @business.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /businesses/1
  # PUT /businesses/1.xml
  def update
    #@address=Address::getrightaddress params[:address]
    #@currentimgurl= Hash.new
    @currentimg=helper_get_current_image @business
    @business.attributes=params[:business]
    valid=help_process
    #@success=updatewithaddress @business,@address,params[:business],"businessName"
    #@business.address_id=@address.id if(@address.valid?)
    respond_to do |format|
      if valid
        flash[:notice] = 'Business was successfully updated.'
        format.html { redirect_to(@business) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @business.errors, :status => :unprocessable_entity }
      end
    end
  end

  def delete_coverpic
    #logger.debug('request.xhr?'+request.xhr?.to_s)
    if request.xhr?
      begin
        @business=Business.find(params[:id])
        helperdeleteoneimage @business,:coverpic
      rescue Exception => e
        render :update do |page|
          page.alert e.to_s
        end
      end
    else
      render :text => 'unknown request'
    end
  end

  def search
    if(params[:submit_search])
      logger.debug("searching businesses")
      #if(params[:city_id].to_i==-1)
      #  @businesses = Business.paginate :page => params[:page], :joins => {:address=>:city}, :order => 'businesses.created_at DESC',:conditions =>{:cities=>{:state_id=>params[:state_list]}}
      #else
      addrhash=Hash.new
      params[:address].each_pair {|k,v| addrhash[k]=v if !v.blank?}

      @businesses = Business.paginate :page => params[:page], :joins => :address, :order => 'businesses.created_at DESC',:conditions =>{:addresses=>addrhash}
      
    end
    render :search_business
  end

  def updatepics
#    #@imgerrors=[]
#    if(params[:deletepicid])
##      a = Asset.find(:first, :conditions => ["id=? AND attachable_id = ? AND attachable_type = ?", params[:deletepicid], params[:id], Business.to_s])
##      raise ActiveRecord::RecordNotFound unless a
##      a.destroy
#      helper_delete_pic @business,params[:deletepicid]
#    end
#    @parentobj = @business
#    @pics = @parentobj.assets
#    if(params[:updatepicbtn])
#      @imgerrors=process_file_uploads(@pics,params[:attachment])
#      #@business.save
#    end
#    render 'assets/attachpics'
    helper_render_updatepics @business
  end

  private

  # DELETE /businesses/1
  # DELETE /businesses/1.xml
  def destroy
    #cant delete any business
    respond_to do |format|
      #format.html { render :template => "shared/status_#{status.to_s}", :status => 403 }
      format.any  { render :text => "can't delete business", :status => 403 } # only return the status code
    end

#    @business = Business.find(params[:id])
#    @business.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(businesses_url) }
#      format.xml  { head :ok }
#    end
  end

  def help_process
#    if params[:frontpic][:uploaded_data].original_filename != nil
#      if @business.frontpic.nil?
#        @business.build_frontpic(params[:frontpic])
#      else
#        @business.frontpic.attributes=params[:frontpic]
#      end
#    end
#    @frontpic=SingleImage.new(params[:frontpic])
    @address=Address::getrightaddress params[:address]
    valid=@address.valid?
#    valid=@frontpic.valid? && valid
    valid=@business.valid? && valid
    if valid
      @business.address_id=@address.id
      valid=saveandcheckdub @business,"businessName"
    end
#    if valid
##      if params[:frontpic][:uploaded_data].original_filename != nil
##        #@business.frontpic.save
##      end
#      unless @frontpic.filename == nil
#        if(@business.frontpic.nil?)
#          @business.frontpic=@frontpic
#          @business.save
#        else
#          @business.frontpic.attributes=params[:frontpic]
#          @business.frontpic.save
#        end
#      end
#    end
    return valid
  end

  def get_and_check_business
    @business = Business.find(params[:id])
    return check_if_user_can_edit(@business)
  end

end
