class EventsController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :destroy, :edit, :update]
  #before_filter :get_and_check_business, :only => [:edit, :update,:updatepics]

  # GET /businesses
  # GET /businesses.xml
  def index
    @company=Company.find(params[:company_id])
    @events = @company.events.paginate :page => params[:page], :order => 'created_at DESC'
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /businesses/1
  # GET /businesses/1.xml
  def show
    @company=Company.find(params[:company_id])
    @event = @company.events.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /businesses/new
  # GET /businesses/new.xml
  def new
    @company=Company.find(params[:company_id])
    @event = @company.events.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /businesses/1/edit
  def edit
    @company = Company.find(params[:company_id])
    @event = @company.events.find(params[:id])
  end

  # POST /businesses
  # POST /businesses.xml
  def create
    @company=Company.find(params[:company_id])
    @event = @company.events.new params[:event]
    @event.user_id=current_user.id
    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to([@company,@event]) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /businesses/1
  # PUT /businesses/1.xml
  def update
    @company = Company.find(params[:company_id])
    @event = @company.events.find(params[:id])
    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Business ad was successfully updated.'
        format.html { redirect_to([@company,@event]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

end
