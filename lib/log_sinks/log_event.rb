# frozen_string_literal: true

module LogSinks
  # Represents a log event.
  class LogEvent
    def initialize(timestamp, level, logger_name, msg, meta: nil)
      @data = meta || {}
      @data[:timestamp] = timestamp
      @data[:level] = level
      @data[:logger_name] = logger_name
      @data[:message] = msg
    end

    def timestamp
      self[:timestamp]
    end

    def level
      self[:level]
    end

    def logger_name
      self[:logger_name]
    end

    def message
      self[:message]
    end

    def [](key)
      @data[key]
    end
  end
end
