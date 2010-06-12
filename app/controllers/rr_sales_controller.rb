class RrSalesController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :destroy, :edit, :update]
  before_filter :get_and_check_rr_sale, :only => [:edit, :update]
  
  # GET /rr_sales
  # GET /rr_sales.xml
  def index
    if(params[:submit_search])
      recordtemp=params.dup
      recordtemp[:address]=nil
      recordtemp=recordtemp.merge(params[:address])
      if(current_user_session)
        recordtemp[:email]=current_user_session.user_auth.email
      else
        flash[:notice]='You have not logged in yet'
      end
      #logger.debug 'current user session email'+current_user_session.user_auth.email
      #logger.debug recordsave.inspect
      @record=RrSaleRecord.new
      @record.attributes.keys
      recordsave=recordtemp.reject { |key,value| !@record.attributes.keys.include? key }
      
      @record=RrSaleRecord.create(recordsave)
      if(params[:address][:id].blank? && (params[:address][:city_name].blank? || params[:address][:state_id].blank?))
        flash.now[:warning]='a city and state is required for search'
      else
        if params[:address][:id]
          @addressselected=Address.find(params[:address][:id]).attributes.symbolize_keys
        else
          @addressselected=params[:address]
        end

        #flash[:warning]=nil
        addrhash=Hash.new
        pricerange=params[:price_min]..params[:price_max] if(!params[:price_min].blank? && !params[:price_max].blank?)
        squarefeetrange=params[:square_feet_min]..params[:square_feet_max] if(!params[:square_feet_min].blank? && !params[:square_feet_max].blank?)
        @addressselected.each_pair {|k,v| addrhash[k]=v if !v.blank?}

        blk = lambda {|h,k| h[k] = Hash.new(&blk)}
        cond=Hash.new(&blk)
        #cond.default ={}
        cond[:price]=pricerange if pricerange
        cond[:mls_number]=params[:mls_number] if !params[:mls_number].blank?
        #(cond[:residential_realty] ||= {}) << {:square_feet=>squarefeetrange} if squarefeetrange
        cond[:residential_realties][:num_of_beds.gte]=params[:beds] if !params[:beds].blank?
        cond[:residential_realties][:num_bath.gte]=params[:baths] if !params[:baths].blank?
        cond[:residential_realties][:square_feet]=squarefeetrange if squarefeetrange
        cond[:residential_realties][:addresses]=addrhash if(!addrhash.empty?)
        case params[:show_type]
        when 'all'
          #cond[:status]=nil
        when 'pending'
          cond[:status]=AdsCommon::STATUS_PENDING
        else
          cond[:status.not]=AdsCommon::ARRAY_AD_INVALID
        end
        #logger.debug(cond.inspect)
        @rr_sales = RrSale.paginate :page => params[:page], :joins => {:residential_realty=>:address}, :order => sort_order('created_at'), :conditions =>cond
      end
   else
      @rr_sales = RrSale.paginate :conditions=>{:status.not=>AdsCommon::ARRAY_AD_INVALID}, :order => sort_order('created_at'),:page => params[:page], :include=>{:residential_realty => [:address, :user]}
    end

    #rr_sale_array=@rr_sales.map {|x| x.id}

    #thumbups=Thumb.count(:thumbup,:group=>['thumbable_id'],:conditions=>{:thumbable_type=>'RrSale',:thumbable_id=>rr_sale_array})
    
    
    #render :search

    

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rr_sales }
    end
  end

  # GET /rr_sales/1
  # GET /rr_sales/1.xml
  def show
    @rr_sale = RrSale.find(params[:id])
    increment_view(@rr_sale)
    @residential_realty=@rr_sale.residential_realty

    @recentads=RrSale.all(:include=>'residential_realty',:limit=>4,:order=>'created_at')
    #@recentads=RrSale.all(:include=>{:residential_realty=>:address},:limit=>4,:order=>'rr_sales.created_at',:conditions=>{:addresses=>{:city_name=>@residential_realty.address.city_name,:state_id=>@residential_realty.address.state_id}})

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rr_sale }
    end
  end

  def showiframe
    @rr_sale = RrSale.find(params[:id])
    @residential_realty=@rr_sale.residential_realty
    case params[:part]
      when "map"
        render 'widgets/_map', :locals=>{ :mapaddr=>@rr_sale.residential_realty.address },:layout=>'plain'
      when "details"
        render 'detailpart',:layout=>'plain'
      when "video"
        render 'widgets/_picvid', :locals => { :obj=>@rr_sale.residential_realty },:layout=>'plain'
      else
        render :text=>'don\'t know what to show'
    end

  end

  # GET /rr_sales/new
  # GET /rr_sales/new.xml
  def new
    @rr_sale = RrSale.new(:status=>AdsCommon::STATUS_ACTIVE,:sale_category=>1)
    #@address=Address.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rr_sale }
    end
  end

  # GET /rr_sales/1/edit
  def edit
    #@rr_sale = RrSale.find(params[:id])
    #@address=@rr_sale.address
  end

  # POST /rr_sales
  # POST /rr_sales.xml
  def create
    @rr_sale = RrSale.new(params[:rr_sale])
    @rr_sale.user_id=current_user.id
    helper_choose_seller @rr_sale
    respond_to do |format|
      if @rr_sale.save
        flash[:notice] = 'RrSale was successfully created.'
        format.html { redirect_to(@rr_sale) }
        format.xml  { render :xml => @rr_sale, :status => :created, :location => @rr_sale }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rr_sale.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rr_sales/1
  # PUT /rr_sales/1.xml
  def update
    #@rr_sale = RrSale.find(params[:id])
    @rr_sale.attributes=params[:rr_sale]
    helper_choose_seller @rr_sale
    respond_to do |format|
      if @rr_sale.save
        flash[:notice] = 'RrSale was successfully updated.'
        format.html { redirect_to(@rr_sale) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rr_sale.errors, :status => :unprocessable_entity }
      end
    end
  end

  def save_favorite
    if request.xhr?
      helper_save_favorite RrSale
    end
  end

#  def search
#    if(params[:submit_search])
#      addrhash=Hash.new
#      pricerange=params[:price_min]..params[:price_max] if(!params[:price_min].blank? && !params[:price_max].blank?)
#      squarefeetrange=params[:square_feet_min]..params[:square_feet_max] if(!params[:square_feet_min].blank? && !params[:square_feet_max].blank?)
#      params[:address].each_pair {|k,v| addrhash[k]=v if !v.blank?}
#
#      blk = lambda {|h,k| h[k] = Hash.new(&blk)}
#      cond=Hash.new(&blk)
#      #cond.default ={}
#      cond[:price]=pricerange if pricerange
#      cond[:mls_number]=params[:mls_number] if !params[:mls_number].blank?
#      #(cond[:residential_realty] ||= {}) << {:square_feet=>squarefeetrange} if squarefeetrange
#      cond[:residential_realties][:num_of_beds.gte]=params[:beds] if !params[:beds].blank?
#      cond[:residential_realties][:num_bath.gte]=params[:baths] if !params[:baths].blank?
#      cond[:residential_realties][:square_feet]=squarefeetrange if squarefeetrange
#      cond[:residential_realties][:addresses]=addrhash if(!addrhash.empty?)
#      cond[:status.not]=AdsCommon::ARRAY_AD_INVALID if params[:only_valid]=='1'
#      logger.debug(cond.inspect)
#      @rr_sales = RrSale.paginate :page => params[:page], :joins => {:residential_realty=>:address}, :order => sort_order('created_at'), :conditions =>cond
#    end
#    render :search
#  end

  def email
    @rr_sale=RrSale.find(params[:id])
    if(request.post?)
      @admailer=AdMailerModel.new(params[:ad_mailer_model])
      if(@admailer.valid? && (current_user || !@admailer.use_account))
        if(@admailer.use_account)
          AdMailer.deliver_rr_sale_mail_cur_user(current_user,@admailer.to_name,@admailer.to_email,current_user.nickname+' sent you a rr_sale ad',rr_sale_url(@rr_sale),user_url(current_user),@admailer.message)
        else
          AdMailer.deliver_rr_sale_mail(@admailer.from_name,@admailer.from_email,@admailer.to_name,@admailer.to_email,@admailer.from_name+' sent you a rr_sale ad',rr_sale_url(@rr_sale),@admailer.message)
        end
        #AdMailer.deliver_rr_sale_mail(@admailer.from_name,@admailer.from_email,@admailer.to_name,@admailer.to_email,@admailer.from_name+' sent you a rr_sale ad',rr_sale_url(@rr_sale),@admailer.message)
        flash[:alert]='email sent'
        redirect_to :action=>'show'
      end
    else
      @admailer=AdMailerModel.new
    end
  end

  private
  # DELETE /rr_sales/1
  # DELETE /rr_sales/1.xml
  def destroy
    @rr_sale = RrSale.find(params[:id])
    @rr_sale.destroy

    respond_to do |format|
      format.html { redirect_to(rr_sales_url) }
      format.xml  { head :ok }
    end
  end

  def get_and_check_rr_sale
    @rr_sale = RrSale.find(params[:id])
    return check_if_user_can_edit(@rr_sale)
  end
  
  def helper_choose_seller obj
    if current_user.instance_of?(Agent) || (current_user.instance_of?(RegularUser) && params[:sell_by_other]!='1')
      obj.seller_id=current_user.id
    end
    
  end

end
