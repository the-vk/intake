# frozen_string_literal: true

require_relative 'formatter'
require_relative 'sink'

module Intake
  # Sink that writes log events to IO stream, e.g., STDOUT or file stream
  class IOSink < Sink
    def initialize(io)
      super()
      @io = io
      @formatter = ::Intake::Formatter.new
    end

    attr_writer :formatter

    def drain(event)
      txt = @formatter.call(event)
      @io.write(txt)
    end
  end
end
