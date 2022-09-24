# frozen_string_literal: true

module LogSinks
  class Formatter
    def initialize
      @timestamp_format = '%Y-%m-%dT%H:%M:%S.%6N'
    end

    def call(event)
      "#{event.level.to_s[0]}, [#{event.timestamp.strftime(@timestamp_format)} ##{Process.pid}] #{event.level} -- #{event[:progname]}: #{event.message}\n"
    end
  end
end
