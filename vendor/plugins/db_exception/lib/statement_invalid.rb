module ActiveRecord
  # Raised when SQL statement cannot be executed by the database (for example, it's often the case for MySQL when Ruby driver used is too old).
  class StatementInvalid < ActiveRecordError
    attr_reader :adapter_error
      def initialize(message = nil, adapter_error = nil)
        super(message)
          @adapter_error = adapter_error
      end
  end
end