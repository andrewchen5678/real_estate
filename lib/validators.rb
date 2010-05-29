module ActiveRecord
  module Validations
    module ClassMethods

      def validates_price(*attr_names)
        configuration = { :on => :save, :with => /^\d+$|(\.\d{1,2}$)/ }
        configuration.update(attr_names.extract_options!)
        numericality_options = ALL_NUMERICALITY_CHECKS.keys & configuration.keys
        raise(ArgumentError, "A regular expression must be supplied as the :with option of the configuration hash") unless configuration[:with].is_a?(Regexp)

        validates_each(attr_names, configuration) do |record, attr_name, value|
          #logger.debug('value to s'+value.to_s)
          rawvar=record.send("#{attr_name}_before_type_cast") || value
          next if configuration[:allow_nil] and rawvar.nil?
          unless rawvar.to_s =~ configuration[:with]
            record.errors.add(attr_name, :invalid, :default => configuration[:message], :value => value)
            next
          end
          unless rawvar.respond_to? 'to_s'
            record.errors.add(attr_name, :invalid, :default => configuration[:message], :value => value)
          end
          valuebigdec=BigDecimal.new(rawvar)
          (numericality_options - [ :odd, :even ]).each do |option|
                #logger.debug('comparing')
                #logger.debug(valuebigdec.to_s+ALL_NUMERICALITY_CHECKS[option]+configuration[option].to_s)
                record.errors.add(attr_name, option, :default => configuration[:message], :value => value, :count => configuration[option]) unless valuebigdec.method(ALL_NUMERICALITY_CHECKS[option])[configuration[option]]
          end
        end
      end

      def validates_as_email(*attr_names)
        configuration = {
          :message   => 'is an invalid email',
          :with      => /^[A-Z0-9._%-]+@[A-Z0-9._%-]+\.[A-Z]{2,4}$/i,
          :allow_nil => true }
        configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)

        validates_format_of attr_names, configuration
      end
    end
  end
end