# frozen_string_literal: true

module LogSinks
  # Filter is a proc-like object that filters events to be accepted by [LogSinks::Sink]
  class Filter
    # Applies filter to the event
    # @param event [LogSinks::Event] event to filter
    # @return [Boolean] true if [LogSinks::Sink] should accept the event; false otherwise
    def call(_event)
      true
    end
  end
end
