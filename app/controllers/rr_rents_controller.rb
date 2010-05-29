class RrRentsController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :destroy, :edit, :update]
  # GET /rr_rents
  # GET /rr_rents.xml
  def index
    @rr_rents = RrRent.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rr_rents }
    end
  end

  # GET /rr_rents/1
  # GET /rr_rents/1.xml
  def show
    @rr_rent = RrRent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rr_rent }
    end
  end

  # GET /rr_rents/new
  # GET /rr_rents/new.xml
  def new
    @rr_rent = RrRent.new
    #@address=Address.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rr_rent }
    end
  end

  # GET /rr_rents/1/edit
  def edit
    @rr_rent = RrRent.find(params[:id])
    #@address=@rr_rent.address
  end

  # POST /rr_rents
  # POST /rr_rents.xml
  def create
    @rr_rent = RrRent.new(params[:rr_rent])
    @rr_rent.user_id=current_user.id
    respond_to do |format|
      if @rr_rent.save
        flash[:notice] = 'RrRent was successfully created.'
        format.html { redirect_to(@rr_rent) }
        format.xml  { render :xml => @rr_rent, :status => :created, :location => @rr_rent }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rr_rent.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rr_rents/1
  # PUT /rr_rents/1.xml
  def update
    @rr_rent = RrRent.find(params[:id])
    @rr_rent.attributes=params[:rr_rent]
    respond_to do |format|
      if @rr_rent.save
        flash[:notice] = 'RrRent was successfully updated.'
        format.html { redirect_to(@rr_rent) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rr_rent.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
  # DELETE /rr_rents/1
  # DELETE /rr_rents/1.xml
  def destroy
    @rr_rent = RrRent.find(params[:id])
    @rr_rent.destroy

    respond_to do |format|
      format.html { redirect_to(rr_rents_url) }
      format.xml  { head :ok }
    end
  end
end
