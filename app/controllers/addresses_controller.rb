class AddressesController < ApplicationController

  include AddressesHelper
  # GET /addresses
  # GET /addresses.xml
  def index
    #@addresses = Address.all

    if(params)

      searchparams={}

      if(params[:address_id])
        addr=Address.find(params[:address_id])
        searchparams[:origin]=addr
      elsif params[:lat] && params[:lng]
        #addr=Address.find(:lat=>params[:lat],:lng=>params[:lng])
        searchparams[:origin]=[params[:lat],params[:lng]]
      end

      if(params[:within])
        searchparams[:within]=params[:within]
      end

      if params[:s] && params[:w] && params[:n] && params[:e]
        sw_point=[params[:s],params[:w]]
        ne_point=[params[:n],params[:e]]
        searchparams[:bounds]=[sw_point,ne_point]
      end

      addrlist={}
      Address.all(searchparams).each { |a|
        addrlist[a.id]={:address=>format_address(a),:lat=>a.lat,:lng=>a.lng}
      }

#      @addresses=Address.find(:all,:conditions=>{:id.not=>params[:address_id]}, :origin =>[params[:lat],params[:lng]], :within=>15).map { |a|
#          {:address=>format_address(a),:lat=>a.lat,:lng=>a.lng}
#        }.to_json
    end

    respond_to do |format|
      #logger.debug(addrlist.inspect);
      #format.html # index.html.erb
      format.xml  { render :xml => addrlist }
      format.js  { render :json => addrlist }
    end
  end

  # GET /addresses/1
  # GET /addresses/1.xml
  def show
    @address = Address.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @address }
    end
  end

  # GET /addresses/new
  # GET /addresses/new.xml
  def new
    @address = Address.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @address }
    end
  end

  # GET /addresses/1/edit
  def edit
    @address = Address.find(params[:id])
  end

  # POST /addresses
  # POST /addresses.xml
  def create
    @address = Address.new(params[:address])

    respond_to do |format|
      if @address.save
        flash[:notice] = 'Address was successfully created.'
        format.html { redirect_to(@address) }
        format.xml  { render :xml => @address, :status => :created, :location => @address }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @address.errors, :status => :unprocessable_entity }
      end
    end
  end

  def getcitylist
    if request.xhr?
      if(params[:statesel].blank?)
        citylist="<option value=''>Please select state first</option>"
      else
        citylist="<option value=''></option>"
        citylist+="<option value='-1'>--ALL--</option>" if(params[:includeall])
#          cityarr=City.all(:conditions => ["state_id = :st and id
#              IN (SELECT city_id FROM addresses,`#{sanetable}` WHERE addresses.id=`#{sanetable}`.address_id)",
#              {:st=>params[:statesel]}])
        Address.find(:select=>'distinct(city_name)',:conditions => ["state_id = ?", params[:statesel]]).each { |c| citylist+= "<option value='#{c.city_name}'>#{c.city_name}</option>" }
      end

      #logger.debug("params statesel....................."+params[:statesel].to_s)
      render :update do |page|
        page[params[:whichid]].replace_html citylist
      end
    end
  end
  # PUT /addresses/1
  # PUT /addresses/1.xml
  def update
    @address = Address.find(params[:id])

    respond_to do |format|
      if @address.update_attributes(params[:address])
        flash[:notice] = 'Address was successfully updated.'
        format.html { redirect_to(@address) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @address.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
  # DELETE /addresses/1
  # DELETE /addresses/1.xml
  def destroy
    @address = Address.find(params[:id])
    @address.destroy

    respond_to do |format|
      format.html { redirect_to(addresses_url) }
      format.xml  { head :ok }
    end
  end

end
