# frozen_string_literal: true

module Intake
  # Filter is a proc-like object that filters events to be accepted by [Intake::Sink]
  class Filter
    # Applies filter to the event
    # @param event [Intake::Event] event to filter
    # @return [Boolean] true if [Intake::Sink] should accept the event; false otherwise
    def call(_event)
      true
    end
  end
end
