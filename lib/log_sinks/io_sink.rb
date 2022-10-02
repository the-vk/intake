# frozen_string_literal: true

require_relative 'formatter'
require_relative 'sink'

module LogSinks
  # Sink that writes log events to IO stream, e.g., STDOUT or file stream
  class IOSink < Sink
    def initialize(io, pump_class: LogSinks::Pumps::InThreadPump)
      super(pump_class: pump_class)
      @io = io
      @formatter = ::LogSinks::Formatter.new
    end

    attr_writer :formatter

    def drain(event)
      txt = @formatter.call(event)
      @io.write(txt)
    end
  end
end
