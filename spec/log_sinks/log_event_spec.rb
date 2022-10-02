# frozen_string_literal: true

require_relative '../../lib/log_sinks'

# rubocop:disable Metrics/BlockLength
RSpec.describe LogSinks::LogEvent do
  it '#timestamp returns timestamp' do
    ts = Time.new(2022, 1, 1, 13, 51, 41)
    event = LogSinks::LogEvent.new(
      ts,
      LogSinks::Level[:info],
      :root,
      'message'
    )
    expect(event.timestamp).to eq ts
  end

  it '#level returns level' do
    ts = Time.new(2022, 1, 1, 13, 51, 41)
    event = LogSinks::LogEvent.new(
      ts,
      LogSinks::Level[:info],
      :root,
      'message'
    )
    expect(event.level.name).to eq :info
  end

  it '#level returns level' do
    ts = Time.new(2022, 1, 1, 13, 51, 41)
    event = LogSinks::LogEvent.new(
      ts,
      LogSinks::Level[:info],
      :root,
      'message'
    )
    expect(event.logger_name).to eq :root
  end

  it '#message returns message' do
    ts = Time.new(2022, 1, 1, 13, 51, 41)
    event = LogSinks::LogEvent.new(
      ts,
      LogSinks::Level[:info],
      :root,
      'message'
    )
    expect(event.message).to eq 'message'
  end

  it '#[] returns value from meta' do
    ts = Time.new(2022, 1, 1, 13, 51, 41)
    event = LogSinks::LogEvent.new(
      ts,
      LogSinks::Level[:info],
      :root,
      'message',
      meta: { abc: 123 }
    )
    expect(event[:abc]).to eq 123
  end
end
# rubocop:enable Metrics/BlockLength
