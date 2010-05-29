module AddressesHelper

  def format_address(address)
    formatted=address.streetNumber.to_s + ' '
    formatted += address.streetWay + '. ' if !address.streetWay.blank?
    formatted += address.street + ' ' + address.streetRoad + '. '
    formatted+='Unit: '+address.unit + ' ' if(!address.unit.empty?)
    formatted+=address.city_name + ', '+ address.state_id + ' ' + address.zip
    return formatted
  end
  
end
