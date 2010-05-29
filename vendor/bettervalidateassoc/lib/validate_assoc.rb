module ActiveRecord
  module Validations
    module ClassMethods
#      def validates_associated(*attr_names)
#        configuration = { :on => :save }
#        configuration.update(attr_names.extract_options!)
#
#        validates_each(attr_names, configuration) do |record, attr_name, value|
#          unless (value.is_a?(Array) ? value : [value]).collect { |r| r.nil? || r.valid? }.all?
#            r.errors.each do |error_name, error_value|
#              record.errors.add(error_name, error_value)
#            end
#          end
#        end
#      end
      def validates_associated(*attr_names)
        configuration = { :on => :save }
        configuration.update(attr_names.extract_options!)

        validates_each(attr_names, configuration) do |record, attr_name, value|
          (value.is_a?(Array) ? value : [value]).collect { |r| r.nil? || r.valid? }
            #record.errors.add(attr_name, :invalid, :default => configuration[:message], :value => value)
        end
      end
    end
  end
end
