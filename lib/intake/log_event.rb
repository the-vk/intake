# frozen_string_literal: true

module Intake
  # Represents a log event.
  class LogEvent
    attr_reader :timestamp, :level, :logger_name, :message, :data

    def initialize(timestamp, level, logger_name, msg, meta: nil)
      @data = (meta || {}).freeze
      @timestamp = timestamp
      @level = level
      @logger_name = logger_name
      @message = msg
    end

    def [](key)
      @data[key]
    end
  end
end
