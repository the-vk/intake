# frozen_string_literal: true

require_relative 'exception_formatter'
require_relative 'formatter'
require_relative 'sink'

module Intake
  # Sink that writes log events to IO stream, e.g., STDOUT or file stream
  class IOSink < Sink
    def initialize(io)
      super()
      @io = io
      @formatter = ::Intake::Formatter.new
      @exception_formatter = ::Intake::ExceptionFormatter.new
    end

    attr_accessor :formatter, :exception_formatter

    def drain(event)
      error_message = "\n#{@exception_formatter.call(event[:error])}" unless event[:error].nil?
      txt = "#{@formatter.call(event)}#{error_message}\n"
      @io.write(txt)
    end
  end
end
