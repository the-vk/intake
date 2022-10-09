# frozen_string_litral: true

module Intake
  module Pumps
    # A pump that drains events to the sink in the current thread
    class InThreadPump
      def initialize(sink)
        @sink = sink
      end

      def receive(event)
        @sink.drain event
      end
    end
  end
end
