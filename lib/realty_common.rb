#encoding: utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

module RealtyCommon

  HEATER_DESC=ActiveSupport::OrderedHash[1,'中央空調',
    2,'Forced air']
  AC_DESC=ActiveSupport::OrderedHash[1,'中央空調',
    2,'Forced air']

  def self.included(base)
    base.instance_eval do
      include MySerializer

      belongs_to :user
      belongs_to :address

      validates_presence_of :building_year
      validates_numericality_of :building_year, :only_integer=>true, :greater_than_or_equal_to=>1
      validates_numericality_of :square_feet, :greater_than_or_equal_to=>1#  def inside_component=(arr)
#    arr ||= []
#    write_attribute('inside_component', arr.collect {|x| x.to_i if x.respond_to?(:to_i)})
#    #self.inside_component =
#  end


#  def after_initialize
#    self.inside_component=inside_component.collect {|x| x.to_i if x.respond_to?(:to_i)} if inside_component
#  end

#  def after_find
#    self.inside_component=unserialize_array(inside_component)
#    logger.debug("after find"+inside_component.inspect)
#  end

    #serialize :inside_component,Array





    end #eval
  end #self included

  def after_validation
    logger.debug("after validation"+inside_component.inspect)
  end

  def before_save
    #logger.debug("before serialize"+inside_component.inspect)
    #write_attribute('inside_component',serialize_array(inside_component))
    logger.debug("before save"+self[:inside_component].inspect)
  end
end
