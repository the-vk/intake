# frozen_string_literal: true

require_relative '../../lib/log_sinks/event_drain'
require_relative '../../lib/log_sinks/log_event'

RSpec.describe LogSinks::EventDrain do
  after(:each) do
    LogSinks::EventDrain.instance.clear_sinks
  end

  it '#drain forwards event to sinks' do
    event = LogSinks::LogEvent.new(Time.now, LogSinks::Level[:info], 'test_logger', 'msg')
    sink = double(:sink)
    expect(sink).to receive(:drain).with(event)

    event_drain = LogSinks::EventDrain.instance
    event_drain.add_sink(sink)
    event_drain.drain event
  end
end
