# frozen_string_literal: true

require_relative '../../lib/intake'

# rubocop:disable Metrics/BlockLength
RSpec.describe Intake::LogEvent do
  it '#timestamp returns timestamp' do
    ts = Time.new(2022, 1, 1, 13, 51, 41)
    event = Intake::LogEvent.new(
      ts,
      Intake::Level[:info],
      :root,
      'message'
    )
    expect(event.timestamp).to eq ts
  end

  it '#level returns level' do
    ts = Time.new(2022, 1, 1, 13, 51, 41)
    event = Intake::LogEvent.new(
      ts,
      Intake::Level[:info],
      :root,
      'message'
    )
    expect(event.level.name).to eq :info
  end

  it '#level returns level' do
    ts = Time.new(2022, 1, 1, 13, 51, 41)
    event = Intake::LogEvent.new(
      ts,
      Intake::Level[:info],
      :root,
      'message'
    )
    expect(event.logger_name).to eq :root
  end

  it '#message returns message' do
    ts = Time.new(2022, 1, 1, 13, 51, 41)
    event = Intake::LogEvent.new(
      ts,
      Intake::Level[:info],
      :root,
      'message'
    )
    expect(event.message).to eq 'message'
  end

  it '#[] returns value from meta' do
    ts = Time.new(2022, 1, 1, 13, 51, 41)
    event = Intake::LogEvent.new(
      ts,
      Intake::Level[:info],
      :root,
      'message',
      meta: { abc: 123 }
    )
    expect(event[:abc]).to eq 123
  end
end
# rubocop:enable Metrics/BlockLength
