class CompaniesController < ApplicationController
  # GET /companies
  # GET /companies.xml
  #prepend_before_filter :setdontredirectcompany
  before_filter :require_user, :only => [:new, :create, :destroy, :edit, :update,:updatepics,:recommend,:rate]
  before_filter :get_and_check_company, :only => [:edit, :update,:updatepics]

  def index
      @companies = Company.paginate :page => params[:page], :order => sort_order('created_at')

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @companies }
      end
  end

  # GET /companies/1
  # GET /companies/1.xml
  def show
    @company = Company.find(params[:id])
    
    #Company.increment_counter(:num_views, @company.id)
    @agents=@company.staff.find(:all)
    @comments = @company.comments.paginate :page => params[:comment_page], :order => 'created_at DESC'
    @events=@company.events.find(:all,:limit=>3)
    respond_to do |format|
      format.html { 
        increment_view(@company);
        render :html=>@company
      }
      format.xml  { render :xml => @company }
      format.js { render :json => @company.to_json(:include=>:address) }
    end
  end

  # GET /companies/new
  # GET /companies/new.xml
  def new
    @company = Company.new
    @company.build_video
    @address=Address.new
    #@company.build_address
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # GET /companies/1/edit
  def edit
    #@company = Company.find(params[:id])
    @address=@company.address
    if !@company.video
      @company.build_video
    end
  end

  # POST /companies
  # POST /companies.xml
  def create
    #@success=false
    @company = Company.new(params[:company])
    @company.user_id=current_user.id
    @success=help_process
    #@company.address=address
    #Address::getrightaddress(@company,params[:address])
    respond_to do |format|
      if @success
        flash[:notice] = 'Company was successfully created.'
        format.html { redirect_to(@company) }
        format.xml  { render :xml => @company, :status => :created, :location => @company }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /companies/1
  # PUT /companies/1.xml
  def update
    #@company = Company.find(params[:id])
    #@address=Address::getrightaddress params[:address]
    @company.attributes=params[:company]
    @success=help_process
    respond_to do |format|
      if @success
        flash[:notice] = 'Company was successfully updated.'
        format.html { redirect_to(@company) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  def showads
    @company = Company.find(params[:id])
    #Company.increment_counter(:num_views, @company.id)
    increment_view(@company)
    @rr_sales=@company.rr_sales.paginate :page => params[:page]
    render 'rrsales'
  end

  def select
    if(params[:submit_search])
      addrhash=Hash.new
      params[:address].each_pair {|k,v| addrhash[k]=v if !v.blank?}
      @companies = Company.paginate :page => params[:page], :joins => :address, :order => 'companies.created_at DESC',:conditions =>{:addresses=>addrhash}
    end
    render :select, :layout => 'plain'
  end

  def showrandom
    @company=Company.find(:first,:conditions=>"id >= (SELECT CEILING( MAX(id) * RAND()) FROM `companies`)",:limit=>1)
    render 'showrandom',:layout=>'plain'
  end

  # DELETE /companies/1
  # DELETE /companies/1.xml
#  def destroy
#    @company = Company.find(params[:id])
#    @company.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(companies_url) }
#      format.xml  { head :ok }
#    end
#  end

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
    helper_render_updatepics @company
  end

  def agents
    @company = Company.find(params[:id])
    @agents=@company.agents.find(:all)
  end
  
#  def recommend
#    @company = Company.find(params[:id])
#    @company_pick=current_user.company_pick
#    @company_pick=current_user.build_company_pick if(!@company_pick)
#    @company_pick.pickable=@company
#    if(@company_pick.save)
#      flash[:notice]='company recommended'
#      redirect_to :back
#    else
#      render :text => @company_pick.errors
#    end
#
#  end

  def rate
    @company = Company.find(params[:id])

      userid=current_user.id
      @rating=@company.ratings.find_by_user_id(userid, :lock => true)
      if(!@rating)
        @rating=@company.ratings.new :user_id=>userid
      end
      #@rating.user_id=userid
      if(params[:commit])
      #ActiveRecord::Base.transaction do
        @rating.a_star=params[:a_star]
        @rating.b_star=params[:b_star]
        @rating.c_star=params[:c_star]
        @rating.d_star=params[:d_star]
        @rating.average=(@rating.a_star+@rating.b_star+@rating.c_star+@rating.d_star)/4.0
        #@rating.comment=params[:rating][:comment]
        @rating.save!
        #ActiveRecord::Base.connection.update_sql("update #{tb.thumbable.class.table_name} set thumbs_rate = thumbs_up*2 - thumbs_count where id = #{tb.thumbable.id.to_i}")
      #end
    end
#    @company = Company.find(params[:id])
#    @company.rate(params[:stars], current_user, params[:dimension])
#    render :update do |page|
#      page.replace_html @company.wrapper_dom_id(params), ratings_for(@company, params.merge(:wrap => false))
#      page.visual_effect :highlight, @company.wrapper_dom_id(params)
#    end
  end

  private
  def help_process
    @address=Address::getrightaddress params[:address]
    valid=@address.valid?
#    valid=@frontpic.valid? && valid
    valid=@company.valid? && valid
    if valid
      @company.address_id=@address.id
      valid=@company.save
    end
  end

  def get_and_check_company
    @company = Company.find(params[:id])
    return check_if_user_can_edit(@company)
  end

  def setdontredirectcompany
    activate_authlogic
    #setdontredirect if current_user_session.user_auth.user_type=='Agent'
    setdontredirect if current_user_session && current_user_session.user_auth.user_type=='Agent'
  end
  
end
