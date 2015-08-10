#encoding: utf-8
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user, :helpergetcity, :helpergetcitybyclass, :helpergetcityinclass

  before_filter :set_locale
  # helper_method :loggedin?

  # # Scrub sensitive parameters from your log
  # # filter_parameter_logging :password

  # def loggedin?
    # #logger.debug(session[:userid].blank?)
    # return !session[:userid].blank?
    # #return true
  # end

  # def getloggedinuserid
    # return session[:userid]
  # end

  # def login_required
    # if session[:userid]
      # return true
    # end
    # flash[:warning]='Please login to continue'
    # #session[:return_to]=request.request_uri
    # redirect_to :controller => "user", :action => "login", :return_to=>request.request_uri
    # return false
  # end


    private
      def current_user_session
        return @current_user_session if defined?(@current_user_session)
        @current_user_session = UserSession.find
      end

      def current_user
        return @current_user if defined?(@current_user)
        @current_user = current_user_session && current_user_session.user_auth.user
      end

    def require_user
      if !current_user_session
        #store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to login_url(:return_to=>request.request_uri)
        return false
#      elsif !current_user.regcomplete
#        redirect_to_complete_profile
#        return false
      elsif current_user_session && !current_user
        flash[:notice] = "You must complete registration first"
        redirect_to new_user_url
        return false
      end
    end

    def require_no_user
      if current_user
        #store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end

#    def store_location
#      session[:return_to] = request.request_uri
#    end

#    def redirect_back_or_default(default)
#      redirect_to(session[:return_to] || default)
#      session[:return_to] = nil
#    end

    def saveandcheckdub obj,fielddesc="record"
    success=false

        begin
          success=obj.save(false)
        rescue ActiveRecord::StatementInvalid => error
          #logger.debug(YAML::dump(logger.debug('error number'+error.adapter_error.errno.to_s)))
          if ActiveRecord::db_error_is_duplicate? error.adapter_error
            obj.errors.add fielddesc, ' already exists in database'
          else
            raise
          end
        end
      return success
    end

#    def updatewithaddress obj,address,attribs,field="record"
#      success=false
#      #@company.address=address
#      #Address::getrightaddress(@company,params[:address])
#      #attribs.each_pair{|x,y| obj.x=y}
#      obj.attributes=attribs
#      valid=address.valid?
#      valid=obj.valid? && valid
#      if valid
#        obj.address_id=address.id
#        begin
#          success=obj.save(false)
#        rescue ActiveRecord::StatementInvalid => error
#          #logger.debug(YAML::dump(logger.debug('error number'+error.adapter_error.errno.to_s)))
#          if ActiveRecord::db_error_is_duplicate? error.adapter_error
#            obj.errors.add field, ' already exists in database'
#          else
#            raise
#          end
#        end
#      end
#      return success
#    end

    def helperdeleteoneimage obj,imgname
        obj.send(imgname).assign(nil)
        render :update do |page|
          if(obj.save)
            page[imgname].src=obj.send(imgname).url
            page.alert 'image deleted'
            page['delete_coverpic_anchor'].remove
          else
            err=''
            obj.errors.each {|x,y| err+=x+':'+y}
            page.alert(err)
          end
        end
    end

    def helper_get_current_image obj
      return {:url=>obj.coverpic.url,:exists=>obj.coverpic.exists?}
    end

#  def helpergetcity statesel,forclass=nil
#    if(forclass.blank?)
#      return City.all(:conditions => ["state_id = ?", statesel])
#    else
#      case forclass
#         when 'Business'
#           sanetable='businesses'
#         else
#           raise 'unknown table'
#      end
#      return City.all(:conditions => ["state_id = :st and id
#          IN (SELECT city_id FROM addresses,`#{sanetable}` WHERE addresses.id=`#{sanetable}`.address_id)",
#          {:st=>statesel}])
#    end
#  end

    def helpergetcity(statesel)
      return [] if(statesel.blank?)
      return City.all(:conditions => ["state_id = ?",statesel])
    end

    def helpergetcitybyclass statesel,forclass
#      case forclass
#         when 'Business'
#           sanetable='businesses'
#         when 'ResidentialRealty'
#           sanetable='residential_realties'
#         when 'Company'
#           sanetable='companies'
#         else
#           raise 'helpergetcitybyclass:unknown table'
#      end
      sanetable=Kernel.const_get(forclass).table_name
      return Address.all(:select=>'distinct(city_name)',:conditions => ["state_id = :st and id
          IN (SELECT address_id FROM `#{sanetable}`)",{:st=>statesel}],:order=>'city_name')
    end

    def helpergetcityinclass statesel,forclass
#      case forclass
#         when 'Business'
#           sanetable='businesses'
#         when 'ResidentialRealty'
#           sanetable='residential_realties'
#         when 'Company'
#           sanetable='companies'
#         else
#           raise 'helpergetcitybyclass:unknown table'
#      end
      return Kernel.const_get(forclass).all(:select=>'distinct(city_name)',:conditions=>{:state_id=>statesel})
    end

    def check_if_user_can_edit obj
      if(current_user.blank? || obj.user_id!=current_user.id)
        flash[:notice] = "Permission denied"
        redirect_to root_url
        return false
      end
    end

  def process_file_uploads(asset,uploads,maxcount=AttachmentsCommon::Max_Attachments)
    imgerrors=[]
    morethanmax=false
      if(uploads.blank?)
        imgerrors<<"Please select images to upload"
        return imgerrors
      end
      uploads.each do |u|
        if(!morethanmax && asset.count>=maxcount)
          morethanmax=true
        end
        if morethanmax
          imgerrors<<"#{u.original_filename}: total images can't be more than #{maxcount}"
          next
        end
        if !u.blank?
          imgobj=asset.create(:data => u)
          if(imgobj.errors.count>0)
            imgobj.errors.each do |attr,msg|
              imgerrors<<("#{imgobj.name} #{msg}")
            end
          end
        end

        #logger.debug("asset count:#{asset.count}")
      end #uploads.each

      return imgerrors
#      while params[:attachment]['file_'+i.to_s] != "" && !params[:attachment]['file_'+i.to_s].nil?
#
#      end
  end

  def helper_delete_pic obj,pictureid
      #a = Asset.find(:first, :conditions => ["id=? AND attachable_id = ? AND attachable_type = ?", pictureid, obj.id, obj.class.to_s])
      a=obj.assets.find(pictureid)
      raise ActiveRecord::RecordNotFound unless a
      a.destroy
  end

  def set_locale
    # if params[:locale] is nil then I18n.default_locale will be used
    I18n.locale = cookies[:landbooklocale]
  end


#  def checkregcomplete
#    usrsession=current_user_session
#    if !request.xhr? && (!@no_redir_profile && usrsession && !usrsession.user_auth.user)
#      flash[:warning]='please complete registration first'
#      redirect_to new_user_url
#    end
#  end

  def setdontredirect
    @no_redir_profile=true
  end

  def helper_render_updatepics obj
    #@imgerrors=[]
    if(params[:deletepicid])
#      a = Asset.find(:first, :conditions => ["id=? AND attachable_id = ? AND attachable_type = ?", params[:deletepicid], params[:id], Business.to_s])
#      raise ActiveRecord::RecordNotFound unless a
#      a.destroy
      helper_delete_pic obj,params[:deletepicid]
      redirect_to :action=>'updatepics'
    else
      @parentobj = obj
      @pics = @parentobj.assets
      if(params[:updatepicbtn])
        @imgerrors=process_file_uploads(@pics,params[:attachment])
        #@business.save
      end
      render 'assets/attachpics'
    end

  end

  def sort_order(default)
      "#{(params[:c] || default.to_s).gsub(/[\s;'\"]/,'')} #{params[:d] == 'up' ? 'ASC' : 'DESC'}"
  end

  def increment_view obj
    obj.class.increment_counter(:num_views, obj.id)
    obj.reload(:select=>'num_views')
  end

  def helper_save_favorite cls
      render :update do |page|
        if !current_user
          page.alert 'please login first'
        elsif(!params[:id])
          page.alert 'no object specified'
        elsif obj=cls.find(params[:id])
          fav=obj.favorites.find_or_create_by_user_id(current_user.id)
          #rrsale.favorites.create(:user_id=>current_user.id)
          #fav.save!
          page.alert 'favorite saved'
          #page[:favmsg].replace_html '(favorite saved)'
        else
          page.alert 'object not found'
        end
        #page[params[:whichid]].replace_html citylist
      end
  end

    def require_user_session
      if !current_user_session
        #store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to login_url(:return_to=>request.request_uri)
        return false
#      elsif !current_user.regcomplete
#        redirect_to_complete_profile
#        return false
      end
    end

#  def default_url_options(options={})
#    logger.debug "default_url_options is passed options: #{options.inspect}\n"
#    { :locale => I18n.locale }
#  end

end
