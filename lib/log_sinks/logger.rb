# frozen_string_literal: true

require 'time'

require_relative 'level'
require_relative 'log_event'
require_relative 'repository'

module LogSinks
  class Logger
    class << self
      def [](name)
        ::LogSinks::Repository.instance.get_or_add(name) do |logger_name|
          Logger.new(logger_name)
        end
      end
    end

    def initialize(name)
      case name
      when String
        raise ArgumentError, 'logger name must not be empty' if name.empty?
      else
        raise ArgumentError, 'logger name must be a string'
      end

      @level = ::LogSinks::Level[:info]
      @sinks = []
    end

    def add_sink(sink)
      @sinks.push sink
    end

    def level?(level)
      @level.val <= level.val
    end

    def level=(level)
      @level = case level
               when String, Symbol then ::LogSinks::Level[level.to_sym]
               when ::LogSinks::Level then level
               end
    end

    %i[debug info warn error fatal].each do |level|
      code = <<-CODE
        undef :#{level} if method_defined? :#{level}
        def #{level}(msg = nil, meta: nil, error: nil, &block)
          log_event(::LogSinks::Level[:#{level}], msg, meta: meta, error: error, &block)
        end
      CODE
      class_eval(code)
    end

    def log_event(level, msg = nil, meta: nil, error: nil)
      return false if @sinks.empty? || !level?(level)

      msg = yield if msg.nil? && block_given?
      meta ||= {}
      meta[:error] = error unless error.nil?
      event = ::LogSinks::LogEvent.new(Time.now, level, msg, meta: meta)
      dispatch_event event
    end

    private

    def dispatch_event(event)
      @sinks.each do |s|
        s.receive(event)
      end
    end
  end
end
