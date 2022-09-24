# frozen_string_literal: true

module LogSinks
  # Represents a log event.
  class LogEvent
    def initialize(timestamp, level, msg, meta: nil)
      @data = meta || {}
      @data[:timestamp] = timestamp
      @data[:level] = level
      @data[:message] = msg
    end

    def timestamp
      self[:timestamp]
    end

    def level
      self[:level]
    end

    def message
      self[:message]
    end

    def [](key)
      @data[key]
    end
  end
end
