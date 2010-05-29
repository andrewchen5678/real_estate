class CityController < ApplicationController
  def getcitylist
    if request.xhr?
      if(params[:statesel].blank? && params[:forsearch])
        citylist="<option value=''>--ALL--</option>"
      elsif (params[:statesel].blank?)
        citylist="<option value=''>Please select state first</option>"
      else
        
#          cityarr=City.all(:conditions => ["state_id = :st and id
#              IN (SELECT city_id FROM addresses,`#{sanetable}` WHERE addresses.id=`#{sanetable}`.address_id)",
#              {:st=>params[:statesel]}])
        if(params[:forsearch])
          citylist="<option value=''>--ALL--</option>"
          if(params[:inclass] && params[:inclass].to_i)==1
            helpergetcityinclass(params[:statesel],params[:forsearch]).each { |c| citylist+= "<option value='#{c.city_name}'>#{c.city_name}</option>" }
          else
            helpergetcitybyclass(params[:statesel],params[:forsearch]).each { |c| citylist+= "<option value='#{c.city_name}'>#{c.city_name}</option>" }
          end
          #helpergetcitybyclass(params[:statesel],params[:forsearch]).each { |c| citylist+= "<option value='#{c.city_name}'>#{c.city_name}</option>" }
        else
          citylist="<option value=''></option>"
          City.find_each(:conditions => ["state_id = ?", params[:statesel]]) { |c| citylist+= "<option value='#{c.name}'>#{c.name}</option>" }
        end
      end

      #logger.debug("params statesel....................."+params[:statesel].to_s)
      render :update do |page|
        page[params[:whichid]].replace_html citylist
      end
    end
  end

end
