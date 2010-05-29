
module CheckCityState
  def self.included(base)
    base.instance_eval do
      extend ClassMethods
      include InstanceMethods
    end
  end

  module ClassMethods
    def do_check_city_state opt=nil
      if opt
        with_options opt do |l|
          l.validates_presence_of :city_name,:state_id
          l.validate :check_city_state
        end
      else
          validates_presence_of :city_name,:state_id
          validate :check_city_state
      end
    end
  end

  module InstanceMethods
    def check_city_state
      if new_record? || city_name_changed? || state_id_changed?
        if(!City.exists?(['name=? and state_id=?',city_name,state_id]))
          errors.add_to_base('city/state combination doesn\'t exist')
        end
      end
    end
  end
end
