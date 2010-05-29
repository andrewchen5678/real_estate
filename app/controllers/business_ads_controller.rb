class BusinessAdsController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :destroy, :edit, :update,:updatepics]
  #before_filter :get_and_check_business, :only => [:edit, :update,:updatepics]

  # GET /businesses
  # GET /businesses.xml
  def index
    #page = params[:page] || 1
#@posts = Post.paginate_by_board_id @board.id, :page => page, :order => 'updated_at DESC'
    @business_ads = BusinessAd.paginate :page => params[:page], :order => 'created_at DESC'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @business_ads }
    end
  end

  # GET /businesses/1
  # GET /businesses/1.xml
  def show
    @business_ad = BusinessAd.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @business_ad }
    end
  end

  # GET /businesses/new
  # GET /businesses/new.xml
  def new
    @business_ad = BusinessAd.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @business_ad }
    end
  end

  # GET /businesses/1/edit
  def edit
    @business_ad=BusinessAd.find(params[:id])
  end

  # POST /businesses
  # POST /businesses.xml
  def create
    @business_ads = BusinessAd.new params[:business_ad]
    @business_ads.user_id=current_user.id
    respond_to do |format|
      if @business_ads.save
        flash[:notice] = 'Business ad was successfully created.'
        format.html { redirect_to(@business_ads) }
        format.xml  { render :xml => @business_ads, :status => :created, :location => @business_ads }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @business_ads.errors, :status => :unprocessable_entity }
      end
    end
  end

  def search
    if(params[:submit_search])
      logger.debug("searching business ads")
      #if(params[:city_id].to_i==-1)
      #  @businesses = Business.paginate :page => params[:page], :joins => {:address=>:city}, :order => 'businesses.created_at DESC',:conditions =>{:cities=>{:state_id=>params[:state_list]}}
      #else
      addrhash=Hash.new
      params[:address].each_pair {|k,v| addrhash[k]=v if !v.blank?}

        @business_ads = BusinessAd.paginate :page => params[:page], :joins => :address, :order => 'business_ads.created_at DESC',:conditions =>{:addresses=>addrhash}
      #end

    else
      @business_ads=[]
    end
    render :search
  end

  # PUT /businesses/1
  # PUT /businesses/1.xml
  def update
    @business_ad=BusinessAd.find(params[:id])
    respond_to do |format|
      if @business_ad.update_attributes(params[:business_ad])
        flash[:notice] = 'Business ad was successfully updated.'
        format.html { redirect_to(@business_ad) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @business_ad.errors, :status => :unprocessable_entity }
      end
    end
  end

end
