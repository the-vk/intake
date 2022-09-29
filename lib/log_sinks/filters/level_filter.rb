# frozen_string_literal: true

require_relative '../level'
require_relative '../filter'

module LogSinks
  module Filters
    # Filter by event level. Pass if event level is greater or equal to filter level.
    class LevelFilter < Filter
      # Initializes new instance of [LogSinks::Filters::LevelFilter]
      # @param limit_level [LogSinks::Level|Symbol] filter level
      def initialize(limit_level)
        super()
        @limit_level = LogSinks::Level[limit_level]
      end

      # Applies filter to the event
      # @argument event [LogSinks::Event] event to test
      # @return [Boolean] true if event pass the filter; false otherwise
      def call(event)
        event.level >= @limit_level
      end
    end
  end
end
