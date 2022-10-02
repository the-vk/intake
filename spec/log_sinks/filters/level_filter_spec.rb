# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe LogSinks::Filters::LevelFilter do
  it '#call returns true if even level > filter level' do
    event = LogSinks::LogEvent.new(
      Time.new(2022, 1, 1, 13, 51, 41),
      LogSinks::Level[:info],
      :root,
      'message'
    )

    filter = LogSinks::Filters::LevelFilter.new(:debug)
    expect(filter.call(event)).to be true
  end

  it '#call returns true if even level == filter level' do
    event = LogSinks::LogEvent.new(
      Time.new(2022, 1, 1, 13, 51, 41),
      LogSinks::Level[:info],
      :root,
      'message'
    )

    filter = LogSinks::Filters::LevelFilter.new(:info)
    expect(filter.call(event)).to be true
  end

  it '#call returns false if even level < filter level' do
    event = LogSinks::LogEvent.new(
      Time.new(2022, 1, 1, 13, 51, 41),
      LogSinks::Level[:info],
      :root,
      'message'
    )

    filter = LogSinks::Filters::LevelFilter.new(:fatal)
    expect(filter.call(event)).to be false
  end
end
# rubocop:enable Metrics/BlockLength
