# frozen_string_literal: true

require_relative '../../lib/intake/log_event'
require_relative '../../lib/intake/formatter'

RSpec.describe Intake::Formatter do
  it '#call formats message to match Ruby Logger output' do
    event = Intake::LogEvent.new(
      Time.new(2022, 1, 1, 13, 51, 41),
      Intake::Level[:info],
      :root,
      'message'
    )
    formatter = Intake::Formatter.new
    expect(formatter.call(event)).to match(/I, \[2022-01-01T13:51:41.000000 #\d+\] INFO -- : message/)
  end
end
