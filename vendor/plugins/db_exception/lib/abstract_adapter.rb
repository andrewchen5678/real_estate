module ActiveRecord
  module ConnectionAdapters
    class AbstractAdapter
      protected
        def log(sql, name)
          if block_given?
            result = nil
            ms = Benchmark.ms { result = yield }
            @runtime += ms
            log_info(sql, name, ms)
            result
          else
            log_info(sql, name, 0)
            nil
          end
        rescue Exception => e
          # Log message and raise exception.
          # Set last_verification to 0, so that connection gets verified
          # upon reentering the request loop
          @last_verification = 0
          message = "#{e.class.name}: #{e.message}: #{sql}"
          log_info(message, name, 0)
          raise ActiveRecord::StatementInvalid.new(message, e)
        end
     end
  end
end