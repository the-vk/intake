# frozen_string_literal: true

module LogSinks
  # Base class that serializes event to data format acceptable by sink (usually it's [String])
  class Formatter
    def initialize
      @timestamp_format = '%Y-%m-%dT%H:%M:%S.%6N'
    end

    def call(event)
      # rubocop:disable Layout/LineLength
      "#{event.level.to_s[0]}, [#{event.timestamp.strftime(@timestamp_format)} ##{Process.pid}] #{event.level} -- #{event[:progname]}: #{event.message}\n"
      # rubocop:enable Layout/LineLength
    end
  end
end
