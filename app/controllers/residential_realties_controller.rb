class ResidentialRealtiesController < ApplicationController
  include AddressesHelper
  before_filter :require_user, :only => [:new, :create, :destroy, :edit, :update]
  before_filter :get_and_check_residential_realty, :only => [:edit, :update,:updatepics]
  # GET /residential_realties
  # GET /residential_realties.xml
  def index
    @residential_realties = ResidentialRealty.paginate :page => params[:page], :order => 'created_at DESC', :include=>:address

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @residential_realties }
    end
  end

  # GET /residential_realties/1
  # GET /residential_realties/1.xml
  def show
    @residential_realty = ResidentialRealty.find(params[:id])
    increment_view(@residential_realty)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @residential_realty }
      format.js   { 
        if(params[:formatted_address_only]=='1')
          render :json=> format_address(@residential_realty.address)
        else
          render :json=> @residential_realty            
        end
       }
    end
  end

  # GET /residential_realties/new
  # GET /residential_realties/new.xml
  def new
    @residential_realty = ResidentialRealty.new
    #@residential_realty.build_r_pud
    #@residential_realty.build_r_condo
    #@residential_realty.build_r_apartment
    @address=Address.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @residential_realty }
    end
  end

  # GET /residential_realties/1/edit
  def edit
    @currentimg=helper_get_current_image @residential_realty
    #@currentimg= {:url=>@residential_realty.coverpic.url,:exists=>@residential_realty.coverpic.exists?}
    @address=@residential_realty.address
  end

  # POST /residential_realties
  # POST /residential_realties.xml
  def create
    @residential_realty = ResidentialRealty.new(params[:residential_realty])
    set_right_residential_type
    #setrightrrattribs
    @residential_realty.user_id=current_user.id
    respond_to do |format|
      if help_process
        flash[:notice] = 'ResidentialRealty was successfully created.'
        format.html { redirect_to(@residential_realty) }
        format.xml  { render :xml => @residential_realty, :status => :created, :location => @residential_realty }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @residential_realty.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /residential_realties/1
  # PUT /residential_realties/1.xml
  def update
    @currentimg=helper_get_current_image @residential_realty
    #@currentimg= {:url=>@residential_realty.coverpic.url,:exists=>@residential_realty.coverpic.exists?}
    @residential_realty.attributes=params[:residential_realty]
    set_right_residential_type
    #setrightrrattribs
    respond_to do |format|
      if help_process
        flash[:notice] = 'ResidentialRealty was successfully updated.'
        format.html { redirect_to(@residential_realty) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @residential_realty.errors, :status => :unprocessable_entity }
      end
    end
  end

  def search
    if(params[:submit_search])
      addrhash=Hash.new
      squarefeetrange=params[:square_feet_min]..params[:square_feet_max] if(!params[:square_feet_min].blank? && !params[:square_feet_max].blank?)
      params[:address].each_pair {|k,v| addrhash[k]=v if !v.blank?}
      cond={}
      cond[:square_feet]=squarefeetrange if squarefeetrange
      cond[:addresses]=addrhash if(!addrhash.empty?)
      @residential_realties = ResidentialRealty.paginate :page => params[:page], :joins => :address, :order => 'residential_realties.created_at DESC',:conditions =>cond, :include=>:address
    end
    render :search
  end

  def select
    if(params[:submit_search])
      addrhash=Hash.new
      params[:address].each_pair {|k,v| addrhash[k]=v if !v.blank?}
      @residential_realties = ResidentialRealty.paginate :page => params[:page], :joins => :address, :order => 'residential_realties.created_at DESC',:conditions =>{:addresses=>addrhash}
    end
    render :select, :layout => 'plain'
  end

  def updatepics
#    #@imgerrors=[]
#    if(params[:deletepicid])
##      a = Asset.find(:first, :conditions => ["id=? AND attachable_id = ? AND attachable_type = ?", params[:deletepicid], params[:id], Business.to_s])
##      raise ActiveRecord::RecordNotFound unless a
##      a.destroy
#      helper_delete_pic @company,params[:deletepicid]
#    end
#    @parentobj = @company
#    @pics = @parentobj.assets
#    if(params[:updatepicbtn])
#      @imgerrors=process_file_uploads(@pics,params[:attachment])
#      #@business.save
#    end
#    render 'assets/attachpics'
    helper_render_updatepics @residential_realty
  end

  def delete_coverpic
    #logger.debug('request.xhr?'+request.xhr?.to_s)
    if request.xhr?
      begin
        @residential_realty=ResidentialRealty.find(params[:id])
        helperdeleteoneimage @residential_realty,:coverpic
      rescue Exception => e
        render :update do |page|
          page.alert e.to_s
        end
      end
    else
      render :text => 'unknown request'
    end
  end

  def save_favorite
    if request.xhr?
      helper_save_favorite ResidentialRealty
    end
  end

  private

  def set_right_residential_type
    if @residential_realty.realty_type=='--other--'
      @residential_realty.realty_type=params[:realty_type_other]
    end
  end

  # DELETE /residential_realties/1
  # DELETE /residential_realties/1.xml
  def destroy
    @residential_realty = ResidentialRealty.find(params[:id])
    @residential_realty.destroy

    respond_to do |format|
      format.html { redirect_to(residential_realties_url) }
      format.xml  { head :ok }
    end
  end

  def help_process
    @address=Address::getrightaddress params[:address]
    valid=@address.valid?
    valid=@residential_realty.valid? && valid
    if valid
      @residential_realty.address_id=@address.id
      valid=@residential_realty.save
    end
    return valid
  end

  def get_and_check_residential_realty
    @residential_realty = ResidentialRealty.find(params[:id])
    return check_if_user_can_edit(@residential_realty)
  end
end
