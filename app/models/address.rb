class Address < ActiveRecord::Base
  STREET_WAY=['E','S','W','N']
  STREET_ROAD=['Dr','St','Blvd','Ave','Rd','Pl','Way','Hwy','Pkwy','Cir','Lane','Al','Arc','Avct','Avd','Avdr','Avex','Bay','Blex','Brch','Brdg','Byps','Cidr','Cl','Com','Cove','Cres','Crsg','Cswy','Ct','Ctav','Cto','Ctr','Cur','Cyn','Diag','Dvdr','Exav','Exbl','Exrd','East','Ext','Exwy','Frwy','Gdns','Glen','Jct','Lndg','Loop','Mall','Mnr','Mtwy','Oh','Ovl','Ovps','Park','Pass','Pike','Pt','Pz','Ramp','Rdex','Row','Rr','Rue','Run','Sky','Sq','Stav','Stct','Stdr','Stex','Stln','Stlp','Stpl','Ter','Tfwy','Thwy','Tktr','Tpke','Tr','Tun','Unps','View','Walk','Wall'];
  has_many :businesses
  has_many :companies
  has_many :residential_realties
  belongs_to :city, :readonly=>true
  before_validation :normalize
  validates_presence_of :streetNumber,:street,:streetRoad,:zip
  validates_numericality_of :streetNumber, :only_integer=>true, :less_than_or_equal_to=>999999
  validates_format_of :street, :with=>/^[A-Za-z\s]+$/
  validates_inclusion_of :streetWay, :in => STREET_WAY, :allow_blank=>true
  validates_inclusion_of :streetRoad, :in => STREET_ROAD
  validates_numericality_of :zip, :only_integer=>true
  validates_length_of :zip, :is=>5
  #validate :check_city_state
  attr_accessible :streetNumber,:streetWay,:street,:streetRoad,:unit,:city_name,:state_id,:zip
  include CheckCityState
  do_check_city_state
  attr_readonly :id,:streetNumber,:streetWay,:street,:streetRoad,:unit,:city_name,:state_id,:zip
  #private :new
  acts_as_mappable
  validate :validatelatlng

  def lat=(value)
    raise "You can't set this attribute. It is read-only"
  end

  def lng=(value)
    raise "You can't set this attribute. It is read-only"
  end

  def loadlatlng=(value)
    raise "You can't set this attribute. It is read-only"
  end

  def self.getrightaddress parammeters
    address=Address.new(parammeters)
      begin
        address.save
      rescue ActiveRecord::StatementInvalid => error
        #logger.debug(YAML::dump(logger.debug('error number'+error.adapter_error.errno.to_s)))
        if ActiveRecord::db_error_is_duplicate? error.adapter_error
          existing=Address.first(:conditions => parammeters)
          address=existing
        else
          raise
        end
      end
    return address
  end

  def lat
    helpergetlatlng
    read_attribute(:lat)
  end

  def lng
    helpergetlatlng
    read_attribute(:lng)
  end

#  def before_save
#    if !self.latlngon
#      loadlatlng
#    end
#  end


#  def self.getrightaddress(obj,parammeters)
#    #logger.debug("obj to sf"+obj.class.to_s)
#    obj.build_address(parammeters)
#      begin
#        obj.address.save
#      rescue ActiveRecord::StatementInvalid => error
#        #logger.debug(YAML::dump(logger.debug('error number'+error.adapter_error.errno.to_s)))
#        if ActiveRecord::db_error_is_duplicate? error.adapter_error
#          existing=Address.first(:conditions => parammeters)
#          obj.address=existing
#        else
#          raise
#        end
#      end
#    #return address
#  end

  protected
  def normalize
      self.street=street.strip.split(/\s+/).collect {|i| i.capitalize}.join(' ') unless street.blank?
  end

  def helpergetlatlng
    if !self.latlngon
      if !loadlatlng
        raise 'helpergetlatlng: failed to geocode address'
      end
      save!
    end
  end

#  def validate
#    logger.debug("call validate address: streetway"+streetWay.inspect)
#  end

  def validatelatlng
    if(errors.empty? && latlngon!=true)
      if !loadlatlng
        errors.add_to_base('Geocode address failed')
      end
    end
  end

  def loadlatlng
      formatted=self.streetNumber.to_s + ' '
      formatted += self.streetWay + '. ' if !self.streetWay.blank?
      formatted += self.street + ' ' + self.streetRoad + '. '
      formatted+='Unit: '+self.unit + ' ' if(!self.unit.empty?)
      formatted+=self.city_name + ', '+ self.state_id + ' ' + self.zip
      a=Geokit::Geocoders::MultiGeocoder.geocode formatted
      if !a.success?
        return false
      end
      logger.debug(a.inspect)
      write_attribute(:lat,a.lat)
      write_attribute(:lng,a.lng)
      write_attribute(:latlngon,true)
  end
end
