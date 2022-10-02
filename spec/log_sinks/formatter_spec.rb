# frozen_string_literal: true

require_relative '../../lib/log_sinks/log_event'
require_relative '../../lib/log_sinks/formatter'

RSpec.describe LogSinks::Formatter do
  it '#call formats message to match Ruby Logger output' do
    event = LogSinks::LogEvent.new(
      Time.new(2022, 1, 1, 13, 51, 41),
      LogSinks::Level[:info],
      :root,
      'message'
    )
    formatter = LogSinks::Formatter.new
    expect(formatter.call(event)).to match(/I, \[2022-01-01T13:51:41.000000 #\d+\] INFO -- : message/)
  end
end
