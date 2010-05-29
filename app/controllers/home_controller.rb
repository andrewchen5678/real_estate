class HomeController < ApplicationController
  before_filter :require_user, :only => [:create_ad]
  def index
    if params[:setlocale]
      cookies[:landbooklocale]=params[:setlocale] if I18n.available_locales.include?(params[:setlocale].to_sym)
#      redirect_to :back
      redirect_to root_path
    end
#    rescue ActionController::RedirectBackError
#      redirect_to root_path
  end

  def create_ad
    case (params[:ad_category])
    when "rr_sale"
      redirect_to :controller=>"rr_sales", :action => "new"
    when "rr_rent"
      redirect_to :controller=>"rr_rents",:action => "new"
    end
  end

end
