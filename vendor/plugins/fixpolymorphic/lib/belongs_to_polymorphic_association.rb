
module ActiveRecord
   module Associations
     class BelongsToPolymorphicAssociation < AssociationProxy #:nodoc:
       def replace(record)
        counter_cache_name = @reflection.counter_cache_column

         if record.nil?
          if counter_cache_name && !@owner.new_record?
            record.class.base_class.decrement_counter(counter_cache_name, @owner[@reflection.primary_key_name]) if @owner[@reflection.primary_key_name]
          end

           @target = @owner[@reflection.primary_key_name] = @owner[@reflection.options[:foreign_type]] = nil
         else
           @target = (AssociationProxy === record ? record.target : record)

          if counter_cache_name && !@owner.new_record?
            record.class.base_class.increment_counter(counter_cache_name, record.id)
            record.class.base_class.decrement_counter(counter_cache_name, @owner[@reflection.primary_key_name]) if @owner[@reflection.primary_key_name]
          end


          @updated = true
        end

        loaded
        record
     end
   end
 end
end

