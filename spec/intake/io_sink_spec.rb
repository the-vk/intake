# frozen_string_literal: true

require 'stringio'

require_relative '../../lib/intake/log_event'
require_relative '../../lib/intake/io_sink'

RSpec.describe Intake::IOSink do
  it 'writes to IO stream' do
    event = Intake::LogEvent.new(
      Time.new(2022, 1, 1, 13, 51, 41),
      Intake::Level[:info],
      :root,
      'message'
    )
    io_stream = StringIO.new
    sink = Intake::IOSink.new(io_stream)
    sink.formatter = ->(_) { 'message received' }
    sink.receive(event)
    expect(io_stream.string).to eq 'message received'
  end
end
