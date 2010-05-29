# To change this template, choose Tools | Templates
# and open the template in the editor.

class PolyController  < ApplicationController
  protected
    def find_right_obj
      if(params[:business_id])
        @parentobj=Business.find(params[:business_id])
      elsif params[:company_id]
        @parentobj=Company.find(params[:company_id])
      elsif params[:user_id]
        #userobj=
        @parentobj=User.find(params[:user_id])
      elsif params[:rr_sale_id]
        #userobj=
        @parentobj=RrSale.find(params[:rr_sale_id])
      elsif params[:residential_realty_id]
        #userobj=
        @parentobj=ResidentialRealty.find(params[:residential_realty_id])
      end
    end
end
