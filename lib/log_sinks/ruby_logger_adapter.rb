# frozen_string_literal: true

require 'logger'

require_relative 'level'
require_relative 'logger'

module LogSinks
  class Logger
    def as_ruby_logger(progname: nil)
      RubyLoggerAdapter.new(self, progname)
    end
  end

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

  class RubyLoggerAdapter
    %i[DEBUG INFO WARN ERROR FATAL UNKNOWN].each do |l|
      code = <<-CODE
        LEVEL_#{l} = ::LogSinks::Level[::Logger::Severity::#{l}]

        def #{l.downcase}(progname = nil, &block)
          log_event(LEVEL_#{l}, nil, progname, &block)
        end
      CODE
      class_eval(code)
    end

    def unknown(progname = nil, &block)
      add(LEVEL_UNKNOWN, nil, progname, &block)
    end

    def initialize(logger, progname)
      @progname = progname
      @logger = logger
    end

    def add(severity, message = nil, progname = nil, &block)
      severity = ::LogSinks::Level[severity] unless severity.is_a? ::LogSinks::Level
      log_event(severity, message, progname, &block)
    end

    private

    def log_event(severity, message, progname, &block)
      progname = @progname if progname.nil?

      if message.nil?
        if block.nil?
          message = progname
          progname = @progname
        else
          message = block.call
        end
      end
      # @logger.log_event(severity, message, meta: { progname: progname }, &block)
      @logger.log_event(severity, message, meta: nil, &block)
    end
  end
end
