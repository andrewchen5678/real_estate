module ProfilesCommon

  def self.included(base)
    base.instance_eval do
      include MySerializer
#      validates_presence_of :first_name,:last_name,:nickname
#      validates_inclusion_of :gender, :in=>%w{M F}
#      define_int_array_setters :language
    end
  end
end
