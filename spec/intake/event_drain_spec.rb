# frozen_string_literal: true

require_relative '../../lib/intake/event_drain'
require_relative '../../lib/intake/log_event'

RSpec.describe Intake::EventDrain do
  after(:each) do
    Intake::EventDrain.instance.clear_sinks
  end

  it '#drain forwards event to sinks' do
    event = Intake::LogEvent.new(Time.now, Intake::Level[:info], 'test_logger', 'msg')
    sink = double(:sink)
    expect(sink).to receive(:receive).with(event)

    event_drain = Intake::EventDrain.instance
    event_drain.add_sink(sink)
    event_drain.drain event
  end
end
