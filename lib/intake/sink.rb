# frozen_string_literal: true

require_relative 'filter'

module Intake
  # Sink receives log event and writes to a permanent storage.
  class Sink
    def initialize
      @filters = []
    end

    def flush
      @has_events_flag.set if @thread_model == :dedicated_thread
    end

    def receive(event)
      return unless accept_event?(event)

      drain event
    end

    def add_filter(filter)
      @filters << filter
    end

    # Receives a message and write to a permanent storage
    def drain(_event)
      nil
    end

    protected

    def accept_event?(event)
      proceed = true
      @filters.each do |f|
        proceed &&= f.call(event)
        break unless proceed
      end
      proceed
    end
  end
end
