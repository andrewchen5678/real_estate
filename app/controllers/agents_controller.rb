class AgentsController < ApplicationController

  def index
    #@agents = Agent.all
    if(params[:submit_search])
      helper_search
    else
      @agents = Agent.paginate :order => sort_order('created_at'),:page => params[:page]
    end
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @agents }
#    end

    #rr_sale_array=@users.map {|x| x.id}

    #thumbups=Thumb.count(:thumbup,:group=>['thumbable_id'],:conditions=>{:thumbable_type=>'RrSale',:thumbable_id=>rr_sale_array})


    #render :search



    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @agents }
    end
  end

  def getagent
    @agent=Agent.find(params[:agent_id])
    logger.debug(@agent.attributes.to_json)
    render :json => @agent.attributes
  end

  def select
    if(params[:submit_search])
      helper_search
    end
    render :select, :layout => 'plain'
  end

  def showrandom
    @agent=Agent.find(:first,:conditions=>"id >= (SELECT CEILING( MAX(id) * RAND()) FROM `users` where type='Agent' )",:limit=>1)
    render 'showrandom',:layout=>'plain'
  end

  private
  def helper_search

      condstr=''
      condhash={}
      if(params[:name_start])
        condstr+="(first_name like :name_start or last_name like :name_start)"
        condhash[:name_start]=params[:name_start]+'%'
        #params[:name_start],params[:name_start])
      end

      if(!params[:city_name].blank?)
        if(!condstr.blank?)
          condstr+=' and '
        end
        condstr+="city_name=:city_name"
        condhash[:city_name]=params[:city_name]
      end

      if(!params[:state_id].blank?)
        if(!condstr.blank?)
          condstr+=' and '
        end
        condstr+="state_id=:state_id"
        condhash[:state_id]=params[:state_id]
      end
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
      #logger.debug(cond.inspect)
      @agents = Agent.paginate :page => params[:page], :order => sort_order('created_at'), :conditions =>[condstr,condhash]
  end

end