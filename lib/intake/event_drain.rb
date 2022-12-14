# frozen_string_literal: true

require 'singleton'

module Intake
  # EventDrain is a single receiver of messages from loggers. EventDrain forward events to registered sinks
  class EventDrain
    include Singleton

    def initialize
      @sinks = []
    end

    def add_sink(sink)
      @sinks << sink
    end

    def drain(event)
      @sinks.each { |s| s.receive(event) }
    end

    def clear_sinks
      @sinks.clear
    end
  end
end
