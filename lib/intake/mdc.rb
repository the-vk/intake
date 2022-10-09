# frozen_string_literal: true

module Intake
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
        if Thread.current[:intake_mdc].nil?
          SYNC_MUTEX.synchronize do
            Thread.current[:intake_mdc] = {} if Thread.current[:intake_mdc].nil?
          end
        end
        Thread.current[:intake_mdc]
      end
    end
  end
end
