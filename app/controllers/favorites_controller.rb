
class FavoritesController  < ApplicationController
#  before_filter :require_user, :only => [:new, :create, :destroy, :edit, :update]
#  #before_filter :get_and_check_favorite, :only => [:edit, :update,:updatepics]
#  # GET /residential_realties
#  # GET /residential_realties.xml
#  def index
#    @favorites = Favorites.paginate :page => params[:page], :order => 'created_at DESC', :include=>:favoritable
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @favorites }
#    end
#  end
#
#  # POST /residential_realties
#  # POST /residential_realties.xml
#  def create
#    @residential_realty = ResidentialRealty.new(params[:residential_realty])
#    set_right_residential_type
#    #setrightrrattribs
#    @residential_realty.user_id=current_user.id
#    respond_to do |format|
#      if help_process
#        flash[:notice] = 'ResidentialRealty was successfully created.'
#        format.html { redirect_to(@residential_realty) }
#        format.xml  { render :xml => @residential_realty, :status => :created, :location => @residential_realty }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @residential_realty.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  def destroy
#    @residential_realty = ResidentialRealty.find(params[:id])
#    @residential_realty.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(residential_realties_url) }
#      format.xml  { head :ok }
#    end
#  end
#
#  private
#  # GET /residential_realties/1
#  # GET /residential_realties/1.xml
#  def show
#    @residential_realty = ResidentialRealty.find(params[:id])
#    increment_view(@residential_realty)
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @residential_realty }
#    end
#  end
#
#  # GET /residential_realties/new
#  # GET /residential_realties/new.xml
#  def new
#    @residential_realty = ResidentialRealty.new
#    #@residential_realty.build_r_pud
#    #@residential_realty.build_r_condo
#    #@residential_realty.build_r_apartment
#    @address=Address.new
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @residential_realty }
#    end
#  end
#
#  # GET /residential_realties/1/edit
#  def edit
#    @address=@residential_realty.address
#  end
#
#  # PUT /residential_realties/1
#  # PUT /residential_realties/1.xml
#  def update
#    @residential_realty.attributes=params[:residential_realty]
#    set_right_residential_type
#    #setrightrrattribs
#    respond_to do |format|
#      if help_process
#        flash[:notice] = 'ResidentialRealty was successfully updated.'
#        format.html { redirect_to(@residential_realty) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @residential_realty.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
end
