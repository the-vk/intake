# frozen_string_literal: true

module LogSinks
  # Mapped Diagnostic Context (MDC) is thread-aware Hash-like storage to add extra context details to logged events.
  module MDC
    SYNC_MUTEX = Mutex.new

    class << self
      def []=(key, value)
        context[key] = value
      end

      def clear(key)
        context.delete(key)
        nil
      end

      def store(key, value)
        MDC[key] = value
      end

      def any?
        context.any?
      end

      def items
        context.dup.freeze
      end

      private

      def context
        if Thread.current[:log_sinks_mdc].nil?
          SYNC_MUTEX.synchronize do
            Thread.current[:log_sinks_mdc] = {} if Thread.current[:log_sinks_mdc].nil?
          end
        end
        Thread.current[:log_sinks_mdc]
      end
    end
  end
end
