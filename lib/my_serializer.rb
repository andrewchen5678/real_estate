module MySerializer
    #@intarrs={}
    def self.included(base) # :nodoc:
      base.extend ClassMethods
      #base.instance_variable_set(:@intarrs,{})
    end

    def serialize_array(arr,delim=';')
      arr ||= []
      arr.join(delim)
    end

    def unserialize_array(str,delim=';')
      str ||= ""
      str.split(delim)
    end

#    def serialize_array(arr,delim=';')
#      arr ||= []
#      delim+arr.join(delim)+delim
#    end
#
#    def unserialize_array(str,delim=';')
#      str ||= delim+delim
#      str[1..-2].split(delim)
#    end
    
    module ClassMethods
      
      def define_int_array_setters(*fields)
        @intarrs ||= {}
        intarr=@intarrs
        #logger.debug("intarr"+intarr.inspect)
        fields.each do |field|
          define_method("#{ field }=") do |arr|
            #logger.debug("intarr"+intarr.inspect)
            #logger.debug("@intarr"+@intarrs.inspect)
            arr ||= []
            ai=arr.collect {|x| x.to_i if x.respond_to?(:to_i)}
            intarr[field]=ai
            write_attribute(field, serialize_array(ai))
          end

          define_method(field) do
            #logger.debug("intarr"+intarr.inspect)
            #logger.debug("@intarr"+@intarrs.inspect)
            #logger.debug("@@intarrs[field] before "+field.to_s+":"+@intarrs[field].inspect)
            intarr[field]=(unserialize_array(self[field]).collect {|x| x.to_i if x.respond_to?(:to_i)})
            #logger.debug("@@intarrs "+field.to_s+":"+@intarrs[field].inspect)
            intarr[field]
#            f=self[field]
#            f = f || []
#            self[field]=f.is_a?(Array) ? f : unserialize_array(f).collect {|x| x.to_i if x.respond_to?(:to_i)}
#            logger.debug("self "+field.to_s+":"+self[field].inspect)
#            self[field]
          end
        end
      end

#      def define_array_setters(*fields)
#        fields.each do |field|
#          define_method("#{ field }=") do |arr|
#            arr ||= []
#            write_attribute(field, arr)
#          end
#        end
#      end
    end
end
