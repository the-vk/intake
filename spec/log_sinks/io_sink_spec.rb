# frozen_string_literal: true

require 'stringio'

require_relative '../../lib/log_sinks/log_event'
require_relative '../../lib/log_sinks/io_sink'

RSpec.describe LogSinks::IOSink do
  it 'writes to IO stream' do
    event = LogSinks::LogEvent.new(
      Time.new(2022, 1, 1, 13, 51, 41),
      LogSinks::Level[:info],
      :root,
      'message'
    )
    io_stream = StringIO.new
    sink = LogSinks::IOSink.new(io_stream)
    sink.formatter = ->(_) { 'message received' }
    sink.drain(event)
    expect(io_stream.string).to eq 'message received'
  end
end
