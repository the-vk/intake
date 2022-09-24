# frozen_string_literal: true

require_relative 'formatter'
require_relative 'sink'

module LogSinks
  class IOSink < Sink
    def initialize(io)
      super()
      @io = io
      @formatter = ::LogSinks::Formatter.new
    end

    attr_writer :formatter

    def receive(event)
      txt = @formatter.call(event)
      @io.write(txt)
    end
  end
end
