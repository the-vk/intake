# frozen_string_literal: true

require 'time'

require_relative 'event_drain'
require_relative 'level'
require_relative 'log_event'
require_relative 'mdc'
require_relative 'repository'

module Intake
  # Logger is a object that captures log event and forward that to event sinks.
  class Logger
    DEFAULT_LEVEL = ::Intake::Level[:info]
    class << self
      def [](name)
        ::Intake::Repository.instance.get_or_add(name) do |logger_name, parent|
          Logger.new(logger_name, parent: parent)
        end
      end
    end

    attr_reader :name

    def initialize(name, parent: nil)
      validate_name(name)

      @name = name
      @level = nil
      @parent = parent
    end

    def level?(level)
      self.level.val <= level.val
    end

    def level
      @level || @parent&.level || DEFAULT_LEVEL
    end

    def level=(level)
      @level = case level
               when String, Symbol then ::Intake::Level[level.to_sym]
               when ::Intake::Level then level
               when nil then nil
               end
    end

    %i[debug info warn error fatal].each do |level|
      code = <<-CODE
        undef :#{level} if method_defined? :#{level}
        LEVEL_#{level} = ::Intake::Level[:#{level}]

        def #{level}(msg = nil, meta: nil, error: nil, &block)
          log_event(LEVEL_#{level}, msg, meta: meta, error: error, &block)
        end
      CODE
      class_eval(code)
    end

    def log_event(level, msg = nil, meta: nil, error: nil)
      return false unless level?(level)

      msg = yield if msg.nil? && block_given?
      meta ||= {}
      meta[:error] = error unless error.nil?
      meta.merge!(MDC.items) if MDC.any?
      event = ::Intake::LogEvent.new(Time.now, level, @name, msg, meta: meta)
      dispatch_event event
    end

    private

    def validate_name(name)
      case name
      when String
        raise ArgumentError, 'logger name must not be empty' if name.empty?
      else
        raise ArgumentError, 'logger name must be a string'
      end
    end

    def dispatch_event(event)
      EventDrain.instance.drain(event)
    end
  end
end
