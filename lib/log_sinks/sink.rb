# frozen_string_literal: true

require_relative 'filter'

module LogSinks
  # Sink receives log event and writes to a permanent storage.
  class Sink
    def initialize
      @filters = []
    end

    def drain(event)
      proceed = true
      @filters.each do |f|
        proceed &&= f.call(event)
        break unless proceed
      end
      return unless proceed

      receive(event)
    end

    def add_filter(filter)
      @filters << filter
    end

    protected

    # Receives a message and write to a permanent storage
    def receive(_event)
      nil
    end
  end
end
