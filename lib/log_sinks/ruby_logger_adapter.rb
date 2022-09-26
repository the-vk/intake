# frozen_string_literal: true

require 'logger'

require_relative 'logger'

module LogSinks
  class Logger
    def as_ruby_logger(progname: nil)
      RubyLoggerAdapter.new(self, progname)
    end
  end

  class RubyLoggerAdapter
    def initialize(logger, progname)
      @progname = progname
      @logger = logger
    end

    def add(severity, message = nil, progname = nil, &block)
      progname = @progname if progname.nil?

      if message.nil?
        if block.nil?
          message = progname
          progname = @progname
        else
          message = block.call
        end
      end
      @logger.log_event(::LogSinks::Level[severity], message, meta: { progname: progname }, &block)
    end

    def debug(progname = nil, &block)
      add(::Logger::Severity::DEBUG, nil, progname, &block)
    end

    def info(progname = nil, &block)
      add(::Logger::Severity::INFO, nil, progname, &block)
    end

    def warn(progname = nil, &block)
      add(::Logger::Severity::WARN, nil, progname, &block)
    end

    def error(progname = nil, &block)
      add(::Logger::Severity::ERROR, nil, progname, &block)
    end

    def fatal(progname = nil, &block)
      add(::Logger::Severity::FATAL, nil, progname, &block)
    end

    def unknown(progname = nil, &block)
      add(::Logger::Severity::FATAL, nil, progname, &block)
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
end
