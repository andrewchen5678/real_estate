class CommercialRealtiesController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :destroy, :edit, :update]
  # GET /commercial_realties
  # GET /commercial_realties.xml
  def index
    @commercial_realties = CommercialRealty.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @commercial_realties }
    end
  end

  # GET /commercial_realties/1
  # GET /commercial_realties/1.xml
  def show
    @commercial_realty = CommercialRealty.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @commercial_realty }
    end
  end

  # GET /commercial_realties/new
  # GET /commercial_realties/new.xml
  def new
    @commercial_realty = CommercialRealty.new
    @address=Address.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @commercial_realty }
    end
  end

  # GET /commercial_realties/1/edit
  def edit
    @commercial_realty = CommercialRealty.find(params[:id])
    @address=@commercial_realty.address
  end

  # POST /commercial_realties
  # POST /commercial_realties.xml
  def create
    @commercial_realty = CommercialRealty.new(params[:commercial_realty])
    @commercial_realty.user_id=current_user.id
    respond_to do |format|
      if help_process
        flash[:notice] = 'commercialRealty was successfully created.'
        format.html { redirect_to(@commercial_realty) }
        format.xml  { render :xml => @commercial_realty, :status => :created, :location => @commercial_realty }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @commercial_realty.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /commercial_realties/1
  # PUT /commercial_realties/1.xml
  def update
    @commercial_realty = CommercialRealty.find(params[:id])
    @commercial_realty.attributes=params[:commercial_realty]
    respond_to do |format|
      if help_process
        flash[:notice] = 'commercialRealty was successfully updated.'
        format.html { redirect_to(@commercial_realty) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @commercial_realty.errors, :status => :unprocessable_entity }
      end
    end
  end

  def search
    if(params[:submit_search])
      logger.debug("searching commercial realties")
      #if(params[:city_id].to_i==-1)
      #  @businesses = Business.paginate :page => params[:page], :joins => {:address=>:city}, :order => 'businesses.created_at DESC',:conditions =>{:cities=>{:state_id=>params[:state_list]}}
      #else
      addrhash=Hash.new
      params[:address].each_pair {|k,v| addrhash[k]=v if !v.blank?}

        @commercial_realties = CommercialRealty.paginate :page => params[:page], :joins => :address, :order => 'commercial_realties.created_at DESC',:conditions =>{:addresses=>addrhash}
      #end

    else
      #@commercial_realties=[]
    end
    render :search
  end

  private
  # DELETE /commercial_realties/1
  # DELETE /commercial_realties/1.xml
  def destroy
    @commercial_realty = CommercialRealty.find(params[:id])
    @commercial_realty.destroy

    respond_to do |format|
      format.html { redirect_to(commercial_realties_url) }
      format.xml  { head :ok }
    end
  end

  def help_process
    @address=Address::getrightaddress params[:address]
    valid=@address.valid?
    valid=@commercial_realty.valid? && valid
    if valid
      @commercial_realty.address_id=@address.id
      valid=@commercial_realty.save
    end
    return valid
  end
end
