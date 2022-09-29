# frozen_string_literal: true

require 'logger'

require_relative 'level'
require_relative 'logger'

module LogSinks
  # Logger is a object that captures log event and forward that to event sinks.
  class Logger
    def as_ruby_logger(progname: nil)
      RubyLoggerAdapter.new(self, progname)
    end
  end

  # Adapter for [LogSinks::Logger] to match [::Logger] interface.
  class RubyLoggerAdapter
    [
      [::Logger::DEBUG, ::LogSinks::Level[:debug]],
      [::Logger::INFO, ::LogSinks::Level[:info]],
      [::Logger::WARN, ::LogSinks::Level[:warn]],
      [::Logger::ERROR, ::LogSinks::Level[:error]],
      [::Logger::FATAL, ::LogSinks::Level[:fatal]],
      [::Logger::UNKNOWN, ::LogSinks::Level[:fatal]]
    ].each do |(n, v)|
      ::LogSinks::Level[n] = v
    end

    %i[DEBUG INFO WARN ERROR FATAL UNKNOWN].each do |l|
      code = <<-CODE
        LEVEL_#{l} = ::LogSinks::Level[::Logger::Severity::#{l}]

        def #{l.downcase}(progname = nil, &block)
          log_event(LEVEL_#{l}, nil, progname, &block)
        end
      CODE
      class_eval(code)
    end

    def initialize(logger, progname)
      @progname = progname
      @logger = logger
      @meta = { progname: @progname }
    end

    def add(severity, message = nil, progname = nil, &block)
      severity = ::LogSinks::Level[severity] unless severity.is_a? ::LogSinks::Level
      log_event(severity, message, progname, &block)
    end

    private

    def log_event(severity, message, progname, &block)
      return true unless @logger.level?(severity)

      progname = @progname if progname.nil?

      if message.nil? && block.nil?
        message = progname
        progname = @progname
      end

      meta = progname == @progname ? @meta : { progname: progname }
      @logger.log_event(severity, message, meta: meta, &block)
      true
    end
  end
end
